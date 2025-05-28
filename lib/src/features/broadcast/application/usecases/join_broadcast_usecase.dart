import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/core/response/response.dart' show BaseResponse;
import 'package:meno_fe_v1/src/core/usecase/usecase.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show ID;

@injectable
class JoinBroadcastUsecase implements UseCase<Broadcast, ID> {
  const JoinBroadcastUsecase({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
    required BackgroundService background,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        _background = background;

  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;
  final BackgroundService _background;

  @override
  Future<Either<BroadcastException, Broadcast>> call(
    ID params,
  ) async {
    final joinedResult = await _facade.joinBroadcast(params);

    final joinedBroadcast = joinedResult.fold((_) => null, (b) => b);

    if (joinedResult.isLeft() || joinedBroadcast == null) {
      // If joining the broadcast failed, return the error/exception
      return Left(
        joinedResult.fold(
          (exception) => exception,
          (_) => const BroadcastUnknownException(),
        ),
      );
    }

    // Ensure there is a `broadcastToken` available
    final broadcastToken = joinedBroadcast.broadcastToken;
    if (broadcastToken == null) {
      const message = 'Broadcast token missing. Cannot start';
      return const Left(BroadcastExceptionWithMessage(message));
    }

    // Attempt to connect to the LiveKit SDK Client
    final liveKitResult = await _liveKit.stream(broadcastToken);

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
      'joinBroadcast',
      {'broadcastId': params.getOrCrash()},
    );

    final joinedResponse = BaseResponse.fromJson(
      socketResult as Map<String, dynamic>,
      (json) => json as dynamic,
    );

    final socketError = joinedResponse.error;
    if (socketError != null) {
      await _liveKit.disconnect();
      final error = _socket.getErrorMessage(socketError);
      return Left(BroadcastExceptionWithMessage(error.message.toString()));
    }

    // Save broadcast details so it can easily be retrieved when a broadcast
    // needs to be reconnected to.
    await Future.microtask(() {
      _facade.saveBroadcastDetails(joinedBroadcast);
      _background.startBroadcastBackgroundProcess(joinedBroadcast);
    });

    // Successfully joined the broadcast
    return Right(joinedBroadcast);
  }
}
