import 'dart:async';

import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/env/env.dart';
import '../features/broadcast/application/broadcast/broadcast_notifier.dart';
import '../features/broadcast/application/timer/timer_notifier.dart';
import '../features/broadcast/domain/domain.dart';

part 'live_kit_service.g.dart';

@riverpod
Stream<RoomEvent> liveKitEventStream(LiveKitEventStreamRef ref) {
  final listener = ref.watch(liveKitNotifierProvider.notifier).listener;
  return listener.emitter.streamCtrl.stream;
}

@riverpod
EventsListener<RoomEvent> liveKitEvent(LiveKitEventRef ref) {
  final listener = ref.watch(liveKitNotifierProvider.notifier).listener;
  final bNotifier = ref.read(broadcastNotifierProvider.notifier);
  // final sNotifier = ref.read(socketServiceProvider.notifier);
  final tNotifier = ref.read(timerNotifierProvider.notifier);

  listener
    ..on<LocalTrackPublishedEvent>((e) {
      bNotifier.setStatus(Status.live);
      tNotifier.start();
    })
    ..on<RoomDisconnectedEvent>((e) {
      bNotifier.setStatus(Status.offAir);
      tNotifier.stop();
    })
    ..on<RoomReconnectedEvent>((e) => bNotifier.setStatus(Status.live))
    ..on<RoomReconnectingEvent>((e) => bNotifier.setStatus(Status.reconnecting))
    ..on<ParticipantConnectedEvent>((e) {
      Logger().e("Participant Connected: $e");
    })
    ..on<ParticipantDisconnectedEvent>((e) {
      Logger().e("Participant Disconnected: $e");
    });

  return listener;
}

@riverpod
class LiveKitNotifier extends _$LiveKitNotifier {
  late Room room;
  late EventsListener<RoomEvent> listener;

  @override
  AsyncValue<Room> build() {
    room = Room();
    listener = room.createListener();

    ref.watch(liveKitEventProvider);

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

  Future<void> stream(String token) => connect(token, false);

  Future<void> dispose() async {
    room.removeListener(() {});
    await leave();
    await Future.wait([listener.dispose(), room.dispose()]);
  }

  Future<void> leave() => room.disconnect();

  Future<void> setMute(bool value) async {
    await room.localParticipant?.setMicrophoneEnabled(value);
  }
}
