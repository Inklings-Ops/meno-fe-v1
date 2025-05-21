import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/core.dart';
import 'package:meno_fe_v1/src/core/usecase/usecase.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

final class StartBroadcastParams with EquatableMixin {
  const StartBroadcastParams({
    required this.title,
    required this.description,
    this.artwork,
    this.cohosts,
    this.timeZone,
  });

  final SingleLineString title;
  final BroadcastDescription description;
  final BroadcastArtwork? artwork;
  final List<String>? cohosts;
  final String? timeZone;

  @override
  List<Object?> get props => [title, description, artwork, cohosts, timeZone];
}

@injectable
class StartBroadcastUsecase
    implements UseCase<Broadcast, StartBroadcastParams> {
  const StartBroadcastUsecase({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
    required BackgroundService background,
    required TimezoneService timezone,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        _background = background,
        _timezone = timezone;

  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;
  final BackgroundService _background;
  final TimezoneService _timezone;

  @override
  Future<Either<BroadcastException, Broadcast>> call(
    StartBroadcastParams params,
  ) async {
    final localTimezone = await _timezone.getLocalTimezone();

    // Create the broadcast
    final createdResult = await _facade.createBroadcast(
      title: params.title,
      description: params.description,
      artwork: params.artwork,
      cohosts: params.cohosts,
      timeZone: params.timeZone ?? localTimezone,
    );

    final createdBroadcast = createdResult.fold((_) => null, (b) => b);

    if (createdResult.isLeft() || createdBroadcast == null) {
      // If creating the broadcast failed, return the error/exception
      return Left(
        createdResult.fold(
          (exception) => exception,
          (broadcast) => const BroadcastUnknownException(),
        ),
      );
    }

    // Call the start broadcast endpoint to get the `broadcastToken`
    final startedResult = await _facade.startBroadcast(createdBroadcast.id);

    final startedBroadcast = startedResult.fold(
      (failure) => null,
      (broadcast) => broadcast,
    );

    if (startedResult.isLeft() || startedBroadcast == null) {
      // If the`startBroadcast` endpoint fails, return the error/exception
      return Left(
        startedResult.fold(
          (exception) => exception,
          (broadcast) => const BroadcastUnknownException(),
        ),
      );
    }

    // Ensure there is a `broadcastToken` available
    final broadcastToken = startedBroadcast.broadcastToken;
    if (broadcastToken == null) {
      const message = 'Broadcast token missing. Cannot start';
      return const Left(BroadcastExceptionWithMessage(message));
    }

    // Attempt to connect to the LiveKit SDK Client
    final liveKitResult = await _liveKit.broadcast(broadcastToken);

    if (liveKitResult.isLeft()) {
      // If LiveKit connection fails, return error/exception
      return left(
        liveKitResult.fold(
          (exception) => exception,
          (_) => const BroadcastExceptionWithMessage('Unexpected error'),
        ),
      );
    }

    final socketResult = await _socket.emit(
      'startedBroadcast',
      {'broadcastId': startedBroadcast.id.getOr()},
    );

    final startedResponse = BaseResponse.fromJson(
      socketResult as Map<String, dynamic>,
      (json) => json as dynamic,
    );

    final socketError = startedResponse.error;
    if (socketError != null) {
      await _liveKit.disconnect();
      final error = _socket.getErrorMessage(socketError);
      return Left(BroadcastExceptionWithMessage(error.message.toString()));
    }

    // Set the `startTime` manually, although this is done on the backend
    // and it will be synced with the backend value on next retrieval
    //
    // Save broadcast details so it can easily be retrieved when a broadcast
    // needs to be reconnected to.
    final broadcast = startedBroadcast.copyWith(startTime: DateTime.now());
    await Future.microtask(() {
      _facade.saveBroadcastDetails(broadcast);
      _background.startBroadcastBackgroundProcess(broadcast);
    });

    // Successfully started the broadcast
    return Right(startedBroadcast);
  }
}
