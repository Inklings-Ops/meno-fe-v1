import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/core/response/response.dart' show BaseResponse;
import 'package:meno_fe_v1/src/core/usecase/usecase.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show Uid;

@injectable
class EndBroadcastUsecase implements UseCase<void, Uid<Broadcast>> {
  const EndBroadcastUsecase({
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
  Future<Either<BroadcastException, void>> call(Uid<Broadcast> params) async {
    final socketResult = await _socket.emit(
      'endBroadcast',
      {'broadcastId': params.getOr()},
    );

    final ack = BaseResponse.fromJson(
      socketResult as Map<String, dynamic>,
      (json) => json as dynamic,
    );

    final socketError = ack.error;
    if (socketError != null) {
      final error = _socket.getErrorMessage(socketError);
      return Left(BroadcastExceptionWithMessage(error.message.toString()));
    }

    await _liveKit.disconnect();

    // Save broadcast details so it can easily be retrieved when a broadcast
    // needs to be reconnected to.
    await Future.microtask(() {
      _facade.clearSavedBroadcastDetails();
      _background.stopBroadcastBackgroundProcess();
    });

    // Successfully joined the broadcast
    return const Right(null);
  }
}
