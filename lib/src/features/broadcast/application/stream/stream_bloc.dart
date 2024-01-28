import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/live_kit/bloc/live_kit_bloc.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../timer/cubit/timer_cubit.dart';

part 'stream_bloc.freezed.dart';
part 'stream_event.dart';
part 'stream_state.dart';

@lazySingleton
class StreamBloc extends Bloc<StreamEvent, StreamState> {
  final IBroadcastFacade _facade;
  final LiveKitBloc _liveKit;
  final SocketService _socket;
  final TimerCubit _timer;

  StreamBloc({
    required IBroadcastFacade facade,
    required LiveKitBloc liveKit,
    required SocketService socket,
    required TimerCubit timer,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        _timer = timer,
        super(StreamState.initial()) {
    on<_JoinBroadcast>(_onJoinBroadcast);
    on<_LeaveBroadcast>(_onLeaveBroadcast);
  }

  @override
  Future<void> close() async {
    await _timer.close();
    await _liveKit.close();
    super.close();
  }

  Future<void> _onJoinBroadcast(event, emit) async {
    emit(state.copyWith(loading: true, onJoined: none()));
    final broadcastId = event.broadcastId;

    return await _facade.joinBroadcast(broadcastId: broadcastId).then((res) {
      return res.fold(
        (_) => emit(loading: false, onJoined: some(res)),
        (success) {
          _liveKit.add(LiveKitEvent.connect(success.broadcastToken, false));
          // _socket.emitWithAck(sEJoinBroadcast, {'broadcastId': broadcastId});
          _timer
            ..set(success.broadcast.startTime)
            ..start();
          emit(state.copyWith(
            loading: false,
            onJoined: some(res),
            joinBroadcast: success,
          ));
        },
      );
    });
  }

  void _onLeaveBroadcast(event, emit) {
    emit(state.copyWith(loading: true, onLeave: none()));
    final broadcastId = state.joinBroadcast.broadcast.id;
    _liveKit.add(const LiveKitEvent.disconnect());
    // _socket.emitWithAck(sELeaveBroadcast, {'broadcastId': broadcastId});
    _timer.reset();
    emit(state.copyWith(loading: false, onLeave: some(unit)));
  }
}
