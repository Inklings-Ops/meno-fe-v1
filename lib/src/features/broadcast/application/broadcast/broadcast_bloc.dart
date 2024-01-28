import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/live_kit/bloc/live_kit_bloc.dart';
import '../../../../services/socket/event_names.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../timer/cubit/timer_cubit.dart';

part 'broadcast_bloc.freezed.dart';
part 'broadcast_event.dart';
part 'broadcast_state.dart';

@lazySingleton
class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  final IBroadcastFacade _facade;
  final LiveKitBloc _liveKit;
  // final SocketService _socket;
  final TimerCubit _timer;

  BroadcastBloc({
    required IBroadcastFacade facade,
    required LiveKitBloc liveKit,
    // required SocketService socket,
    required TimerCubit timer,
  })  : _facade = facade,
        _liveKit = liveKit,
        // _socket = socket,
        _timer = timer,
        super(BroadcastState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_EndBroadcast>(_onEndBroadcast);
    on<_StartBroadcast>(_onStartBroadcast);
    on<_DeleteBroadcast>(_onDeleteBroadcast);
    on<_MuteMicrophone>(_onMuteMicrophone);
  }

  @override
  Future<void> close() async {
    await _liveKit.close();
    await _timer.close();
    return super.close();
  }

  void _onInitialize(event, emit) {
    emit(state.copyWith(broadcast: event.broadcast));
  }

  Future<void> _onDeleteBroadcast(event, emit) async {
    emit(state.copyWith(loading: true, onDeleted: none()));

    await _facade
        .deleteBroadcast(broadcastId: event.broadcastId)
        .then((r) => emit(state.copyWith(loading: false, onDeleted: some(r))));
  }

  void _onEndBroadcast(event, emit) {
    emit(state.copyWith(loading: true, onEnded: none()));
    _liveKit.add(const LiveKitEvent.disconnect());
    // _socket.emit(sEEndBroadcast, {'broadcastId': state.broadcast.id});
    _timer.stop();
    emit(state.copyWith(loading: false, onEnded: some(unit)));
  }

  void _onMuteMicrophone(event, emit) {
    _liveKit.add(LiveKitEvent.muteToggled(event.value));
    emit(state.copyWith(isMute: event.value));
  }

  Future<void> _onStartBroadcast(event, emit) async {
    final broadcastId = state.broadcast.id;
    emit(state.copyWith(loading: true, onStarted: none()));

    final result = await _facade.startBroadcast(broadcastId: broadcastId);

    result.fold(
      (failure) => emit(state.copyWith(
        loading: false,
        onStarted: some(result),
      )),
      (success) {
        emit(state.copyWith(broadcast: success));
        _liveKit.add(LiveKitEvent.connect(success.broadcastToken!));
        _liveKit.state.mapOrNull(
          connectFailed: (error) => emit(state.copyWith(
            loading: false,
            liveKitError: error.reason,
          )),
          connectSuccess: (_) {
            // _socket.emit(sEStartedBroadcast, {'broadcastId': broadcastId});
            _timer.start();
            emit(state.copyWith(loading: false, onStarted: some(result)));
          },
        );
      },
    );
  }
}
