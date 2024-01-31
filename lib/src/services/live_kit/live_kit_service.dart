import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../core/env/env.dart';

export 'package:livekit_client/livekit_client.dart';

@lazySingleton
class LiveKitService extends Object with Disposable {
  late Room room;
  late EventsListener<RoomEvent> listener;

  Future<void> _connect(String broadcastToken, [bool isHost = true]) async {
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
    } catch (e) {
      throw PlatformException(code: 'live-kit-error', message: e.toString());
    }
  }

  Future<void> broadcast(String broadcastToken) => _connect(broadcastToken);

  Future<void> stream(String broadcastToken) => _connect(broadcastToken, false);

  Future<void> disconnect() => room.disconnect();

  Future<void> mute(bool enabled) async {
    await room.localParticipant?.setMicrophoneEnabled(enabled);
  }

  @override
  FutureOr onDispose() async {
    listener.dispose();
    room.dispose();
  }
}
