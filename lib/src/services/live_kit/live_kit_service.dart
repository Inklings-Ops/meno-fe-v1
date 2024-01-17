import 'dart:async';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/broadcast/meno_event.dart';
import '../../core/env/env.dart';

part 'live_kit_service.g.dart';
part 'live_kit_service.freezed.dart';
part 'live_kit_state.dart';

@riverpod
Future<Room> liveKit(LiveKitRef ref, String token, [bool? isHost]) async {
  final options = FastConnectOptions(
    microphone: TrackOption(enabled: isHost ?? true),
  );

  try {
    final room = Room();

    await room.connect(
      Env.menoLiveKitUrl,
      token,
      fastConnectOptions: options,
    );
    return room;
  } catch (e) {
    final error = e.toString();
    throw PlatformException(code: error, message: error);
  }
}

@riverpod
class LiveKitNotifier extends _$LiveKitNotifier {
  @override
  FutureOr<Room> build() async {
    ref.onDispose(dispose);
    return Room();
  }

  Future<void> _connect(String token, [bool isHost = true]) async {
    state = const AsyncValue.loading();
    final options = FastConnectOptions(
      microphone: TrackOption(enabled: isHost),
    );

    state = await AsyncValue.guard<Room>(() async {
      final room = Room();

      await room.connect(
        Env.menoLiveKitUrl,
        token,
        fastConnectOptions: options,
      );
      return room;
    });
  }

  Future<void> broadcast(String token) async => await _connect(token);

  Future<void> stream(String token) async => await _connect(token, false);

  Future<void> setMute(bool value) async {
    if (!state.hasValue || state.hasError) return;
    await state.value!.localParticipant!.setMicrophoneEnabled(value);
  }

  Future<void> dispose() async {
    if (!state.hasValue || state.hasError) return;
    await state.value!.disconnect();
    await state.value!.dispose();
  }

  Future<void> leave() async => await state.value!.disconnect();
}
