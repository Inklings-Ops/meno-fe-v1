import 'dart:async';

import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/env/env.dart';

part 'live_kit_service.g.dart';

@riverpod
EventsListener<RoomEvent> liveKitEvent(LiveKitEventRef ref) {
  final listener = ref.watch(liveKitNotifierProvider.notifier).listener;
  final Logger log = Logger();
  listener.on<ParticipantConnectedEvent>((e) => log.w(e.participant));
  listener.on<ParticipantDisconnectedEvent>((e) => log.w(e.participant));
  return listener;
}

@riverpod
class LiveKitNotifier extends _$LiveKitNotifier {
  late Room room;
  late EventsListener<RoomEvent> listener;

  @override
  AsyncValue<Room> build() {
    room = Room();
    listener = room.createListener(synchronized: true);
    return AsyncValue.data(room);
  }

  Future<void> connect(String token, [bool isHost = true]) async {
    final FastConnectOptions fastConnectOptions = FastConnectOptions(
      microphone: TrackOption(enabled: isHost),
    );

    state = await AsyncValue.guard(
      () async {
        await room.connect(
          Env.menoLiveKitUrl,
          token,
          fastConnectOptions: fastConnectOptions,
        );
        return room;
      },
    );
  }

  Future<void> dispose() async {
    room.removeListener(() {});
    await Future.wait([leave(), listener.dispose(), room.dispose()]);
  }

  Future<void> leave() => room.disconnect();

  Future<void> setMute(bool value) async {
    await room.localParticipant?.setMicrophoneEnabled(value);
  }
}
