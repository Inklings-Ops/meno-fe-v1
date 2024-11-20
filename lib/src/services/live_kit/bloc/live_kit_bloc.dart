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
        super(const LiveKitState()) {
    on<LiveKitBroadcast>(_onBroadcast);
    on<LiveKitStream>(_onStream);
    on<LiveKitToggleMute>(_onMuteToggled);
    on<LiveKitDisconnect>(_onDisconnect);
  }

  final LiveKitService _liveKit;

  bool get isLoading => state.status is LiveKitConnecting;

  Future<void> _onBroadcast(
    LiveKitBroadcast event,
    Emitter<LiveKitState> emit,
  ) async {
    emit(state.copyWith(status: const LiveKitConnecting()));
    try {
      await _liveKit.broadcast(event.token);
      emit(
        state.copyWith(
          micEnabled: true,
          status: const LiveKitBroadcastConnected(),
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: LiveKitConnectionFailed(error.toString())));
    }
  }

  Future<void> _onStream(
    LiveKitStream event,
    Emitter<LiveKitState> emit,
  ) async {
    emit(state.copyWith(status: const LiveKitConnecting()));
    try {
      await _liveKit.stream(event.token);
      emit(state.copyWith(status: const LiveKitStreamConnected()));
    } catch (error) {
      emit(state.copyWith(status: LiveKitConnectionFailed(error.toString())));
    }
  }

  Future<void> _onMuteToggled(
    LiveKitToggleMute event,
    Emitter<LiveKitState> emit,
  ) async {
    if (state.status is! LiveKitBroadcastConnected) return;
    final micEnabled = !state.micEnabled;
    emit(state.copyWith(micEnabled: micEnabled));
    await _liveKit.mute(enabled: micEnabled);
  }

  Future<void> _onDisconnect(
    LiveKitDisconnect event,
    Emitter<LiveKitState> emit,
  ) async {
    await _liveKit.disconnect();
    emit(state.copyWith(status: const LiveKitDisconnected()));
  }

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    return super.close();
  }
}
