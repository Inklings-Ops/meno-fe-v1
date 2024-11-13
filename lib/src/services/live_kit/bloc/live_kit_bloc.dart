import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/services/live_kit/live_kit_service.dart';

part 'live_kit_bloc.freezed.dart';
part 'live_kit_event.dart';
part 'live_kit_state.dart';

class LiveKitBloc extends Bloc<LiveKitEvent, LiveKitState> {
  LiveKitBloc({required LiveKitService liveKit})
      : _liveKit = liveKit,
        super(const LiveKitInitial()) {
    on<LiveKitBroadcast>(_onBroadcast);
    on<LiveKitStream>(_onStream);
    on<LiveKitToggleMute>(_onMuteToggled);
    on<LiveKitDisconnect>(_onDisconnect);
  }

  final LiveKitService _liveKit;

  bool get isLoading => state is LiveKitLoadInProgress;

  Future<void> _onBroadcast(
    LiveKitBroadcast event,
    Emitter<LiveKitState> emit,
  ) async {
    emit(const LiveKitLoadInProgress());
    try {
      final room = await _liveKit.broadcast(event.token);
      emit(LiveKitBroadcastConnected(room: room));
    } catch (error) {
      emit(LiveKitConnectionFailed(error: error.toString()));
    }
  }

  Future<void> _onStream(
    LiveKitStream event,
    Emitter<LiveKitState> emit,
  ) async {
    emit(const LiveKitLoadInProgress());
    try {
      final room = await _liveKit.stream(event.token);
      emit(LiveKitStreamConnected(room: room));
    } catch (error) {
      emit(LiveKitConnectionFailed(error: error.toString()));
    }
  }

  void _onMuteToggled(LiveKitToggleMute event, Emitter<LiveKitState> emit) {
    if (state is! LiveKitBroadcastConnected) return;
    unawaited(_liveKit.mute(enabled: !event.enabled));
    final currentState = state as LiveKitBroadcastConnected;
    emit(currentState.copyWith(microphoneEnabled: !event.enabled));
  }

  Future<void> _onDisconnect(
    LiveKitDisconnect event,
    Emitter<LiveKitState> emit,
  ) async {
    await _liveKit.disconnect();
    emit(const LiveKitInitial());
  }

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    return super.close();
  }
}
