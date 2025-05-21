import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/core/usecase/usecase.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

@injectable
class ReconnectBroadcastUsecase implements UseCase<Broadcast, bool> {
  const ReconnectBroadcastUsecase({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required BackgroundService background,
  })  : _facade = facade,
        _liveKit = liveKit,
        _background = background;

  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final BackgroundService _background;

  @override
  Future<Either<BroadcastException, Broadcast>> call(bool isStream) async {
    final result = await _facade.getSavedBroadcastDetails();

    final broadcast = result.fold(() => null, (broadcast) => broadcast);
    if (broadcast == null) {
      const message = 'No broadcast saved';
      return const Left(BroadcastExceptionWithMessage(message));
    }

    // Ensure there is a `broadcastToken` available
    final broadcastToken = broadcast.broadcastToken;
    if (broadcastToken == null) {
      const message = 'Broadcast token missing. Cannot connect to LiveKit';
      return const Left(BroadcastExceptionWithMessage(message));
    }

    late Either<BroadcastException, Unit> liveKitResult;
    if (isStream) {
      liveKitResult = await _liveKit.stream(broadcastToken);
    } else {
      liveKitResult = await _liveKit.broadcast(broadcastToken);
    }

    if (liveKitResult.isLeft()) {
      // If LiveKit connection fails, return error/exception
      return left(
        liveKitResult.fold(
          (exception) => BroadcastExceptionWithMessage(exception.toString()),
          (_) => const BroadcastExceptionWithMessage('Unexpected error'),
        ),
      );
    }

    await Future.microtask(
      () => _background.startBroadcastBackgroundProcess(broadcast),
    );

    return Right(broadcast);
  }
}
