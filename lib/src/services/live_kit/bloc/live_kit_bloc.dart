import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../core/env/env.dart';
import '../../meno/meno_bloc.dart';

part 'live_kit_bloc.freezed.dart';
part 'live_kit_event.dart';
part 'live_kit_state.dart';

@lazySingleton
class LiveKitBloc extends Bloc<LiveKitEvent, LiveKitState> {
  final MenoBloc _menoBloc;

  late Room? room;
  late EventsListener<RoomEvent>? listener;

  LiveKitBloc({required MenoBloc menoBloc})
      : _menoBloc = menoBloc,
        super(const _Initial()) {
    on<_ConnectRequested>(_onConnectRequested);
    on<_MuteToggled>(_onMuteToggled);
    on<_DisconnectRequested>(_onDisconnectRequested);
  }

  @override
  Future<void> close() {
    listener?.dispose();
    room?.dispose();
    return super.close();
  }

  void _emit(MenoState s) => _menoBloc.add(MenoStateChanged(s));

  Future<void> _onConnectRequested(
    _ConnectRequested event,
    Emitter<LiveKitState> emit,
  ) async {
    emit(const _Loading());

    // Create a new room
    room = Room();

    // Set a Listener before connecting
    listener = room?.createListener(synchronized: true);

    final options = FastConnectOptions(
      microphone: TrackOption(enabled: event.isHost),
    );

    try {
      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room?.connect(
        Env.menoLiveKitUrl,
        event.broadcastToken,
        fastConnectOptions: options,
      );

      emit(_ConnectSuccess(room: room!));

      listener
        ?..on<RoomConnectedEvent>((_) => _emit(const MenoLive()))
        ..on<RoomReconnectedEvent>((_) => _emit(const MenoLive()))
        ..on<RoomDisconnectedEvent>((_) => _emit(const MenoOffAir()))
        ..on<RoomReconnectingEvent>((_) => _emit(const MenoReconnecting()));
    } catch (error) {
      emit(_ConnectFailed('$error'));
    }
  }

  Future<void> _onDisconnectRequested(
    _DisconnectRequested event,
    Emitter<LiveKitState> emit,
  ) async {
    if (state is _ConnectSuccess) {
      final room = (state as _ConnectSuccess).room;
      await room.disconnect().whenComplete(() => emit(const _Initial()));
    }
  }

  Future<void> _onMuteToggled(
    _MuteToggled event,
    Emitter<LiveKitState> emit,
  ) async {
    if (state is _ConnectSuccess) {
      final connectedState = (state as _ConnectSuccess);
      final isMuted = event.value;

      await connectedState.room.localParticipant
          ?.setMicrophoneEnabled(isMuted)
          .whenComplete(() => emit(connectedState.copyWith(isMuted: isMuted)));
    }
  }
}
