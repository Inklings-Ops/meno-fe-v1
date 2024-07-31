import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:rxdart/rxdart.dart';

export 'package:livekit_client/livekit_client.dart';

@lazySingleton
class LiveKitService extends Object with Disposable {
  late Room room;
  late EventsListener<RoomEvent> listener;

  final _events = BehaviorSubject<RoomEvent>();
  Stream<RoomEvent> get eventsStream => _events.stream.asBroadcastStream();

  Future<Room> _connect(String broadcastToken, [bool isHost = true]) async {
    // Create a new room
    room = Room();

    // Set a Listener for the Room Events before connecting
    listener = room.createListener(synchronized: true);

    final options = FastConnectOptions(
      microphone: TrackOption(enabled: isHost),
    );

    try {
      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room.connect(
        Env.menoLiveKitUrl,
        broadcastToken,
        fastConnectOptions: options,
      );

      _setupListener();

      return room;
    } catch (e) {
      throw PlatformException(code: 'live-kit-error', message: e.toString());
    }
  }

  void _setupListener() {
    listener.listen(_events.add);
  }

  Future<Room> broadcast(String broadcastToken) => _connect(broadcastToken);

  Future<Room> stream(String broadcastToken) => _connect(broadcastToken, false);

  Future<void> disconnect() => room.disconnect();

  Future<void> mute({required bool enabled}) async {
    await room.localParticipant?.setMicrophoneEnabled(enabled);
  }

  @override
  FutureOr<void> onDispose() async {
    await _events.close();
    await dispose();
  }

  Future<void> dispose() async {
    room.removeListener(_setupListener);
    await listener.dispose();
    await room.dispose();
    return;
  }
}
