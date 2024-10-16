import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'broadcast_bloc.freezed.dart';
part 'broadcast_state.dart';

@Injectable()
class BroadcastBloc extends Cubit<BroadcastState> {
  BroadcastBloc({
    @factoryParam required Broadcast broadcast,
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(BroadcastState(broadcast: broadcast)) {
    _socketStateSub = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(broadcastStarted: _onSocketData);
    });
  }
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  late final StreamSubscription<SocketState> _socketStateSub;

  Future<void> startBroadcast() async {
    final broadcastId = state.broadcast.id;
    _emitStatus(const LiveLoadInProgress());
    final failureOrBroadcast = await _facade.startBroadcast(broadcastId);
    await failureOrBroadcast.fold(
      (exception) async => _emitStatus(BroadcastFailed(exception)),
      (broadcast) async {
        _socket.emit(SocketStartedBroadcast(broadcastId.getOr()));
        if (state is! BroadcastFailed) {
          try {
            final token = broadcast.broadcastToken!;
            await _liveKit.broadcast(token).whenComplete(() async {
              emit(
                state.copyWith(
                  broadcast: broadcast,
                  status: const BroadcastStarted(),
                ),
              );
            });
          } catch (e) {
            final exception = BroadcastException.message(e.toString());
            _emitStatus(BroadcastFailed(exception));
          }
        }
      },
    );
  }

  Future<void> mute({bool enabled = false}) async {
    if (state.status is BroadcastStarted) {
      unawaited(_liveKit.mute(enabled: enabled));
      _emitStatus(BroadcastStarted(muted: enabled));
    }
  }

  Future<void> endBroadcast(Uid<Broadcast> broadcastId) async {
    if (state.status is BroadcastStarted) {
      _emitStatus(const LiveLoadInProgress());
      _socket.emit(SocketEndBroadcast(broadcastId.getOr()));
      await _liveKit.dispose();
      _emitStatus(BroadcastEnded(EndedBroadcastData.empty()));
    }
  }

  Future<void> deleteBroadcast(Uid<Broadcast> id) async {}

  Future<void> dispose() async => _liveKit.dispose();

  void _onSocketData(dynamic data, String? error) {
    if (error == null) return;
    return _emitStatus(BroadcastFailed(BroadcastException.message(error)));
  }

  void _emitStatus(LiveStatus status) => emit(state.copyWith(status: status));

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    await _socketStateSub.cancel();
    return super.close();
  }
}
