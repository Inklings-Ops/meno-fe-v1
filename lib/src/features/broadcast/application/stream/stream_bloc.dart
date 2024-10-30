import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'stream_bloc.freezed.dart';
part 'stream_state.dart';

@Injectable()
class StreamBloc extends Cubit<StreamState> {
  StreamBloc({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(StreamState(broadcast: Broadcast.empty())) {
    _socketStateSub = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(broadcastJoined: _onSocketData);
    });
    _socketEventSub = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(
        endedBroadcast: (data) => _emitStatus(BroadcastEnded(data)),
      );
    });
  }
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  late final StreamSubscription<SocketState> _socketStateSub;
  late final StreamSubscription<SocketEvent> _socketEventSub;

  Future<void> joinBroadcast(Uid<Broadcast> broadcastId) async {
    _emitStatus(const LiveLoadInProgress());
    final failureOrJoinBroadcast = await _facade.joinBroadcast(broadcastId);
    await failureOrJoinBroadcast.fold(
      (exception) async => _emitStatus(BroadcastFailed(exception)),
      (joinBroadcast) async {
        emit(state.copyWith(broadcast: joinBroadcast.broadcast));

        try {
          final token = joinBroadcast.broadcastToken;
          await _liveKit.stream(token).whenComplete(() async {
            _socket.emit(SocketJoinBroadcast(broadcastId.getOr()));
            if (state is! BroadcastFailed) {
              _emitStatus(const BroadcastJoined());
            }
          });
        } catch (e) {
          final exception = BroadcastException.message(e.toString());
          _emitStatus(BroadcastFailed(exception));
        }
      },
    );
  }

  Future<void> leaveBroadcast(Uid<Broadcast> broadcastId) async {
    if (state.status is BroadcastJoined) {
      _emitStatus(const LiveLoadInProgress());
      _socket.emit(SocketLeaveBroadcast(broadcastId.getOr()));
      await _liveKit.dispose();
      _emitStatus(const BroadcastLeft());
    }
  }

  void _emitStatus(LiveStatus status) => emit(state.copyWith(status: status));

  // void _onSocketData(dynamic data, String? error) {
  //   if (error == null) return;
  //   return _emitStatus(BroadcastFailed(BroadcastException.message(error)));
  // }

  void _onSocketData(dynamic data, String? error) {
    if (error != null) {
      _liveKit.disconnect();
      _emitStatus(BroadcastFailed(BroadcastException.message(error)));
    }
  }

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    await _socketStateSub.cancel();
    await _socketEventSub.cancel();
    await super.close();
  }

  Future<void> dispose() async {
    await _liveKit.dispose();
    await _socketStateSub.cancel();
    await _socketEventSub.cancel();
  }
}
