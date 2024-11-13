import 'dart:async';

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

  late BehaviorSubject<RoomEvent> _events;

  Stream<RoomEvent> get eventsStream => _events.stream.asBroadcastStream();

  Future<Room> _connect(String broadcastToken, [bool isHost = true]) async {
    final completer = Completer<Room>();

    // Create a new room
    room = Room();
    _events = BehaviorSubject<RoomEvent>();

    // Set a Listener for the Room Events before connecting
    listener = room.createListener(synchronized: true);

    try {
      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room.connect(
        Env.menoLiveKitUrl,
        broadcastToken,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(enabled: isHost),
        ),
      );

      _setupListener();
      completer.complete(room);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  /// Sets up the event listener for the room.
  void _setupListener() => listener.listen(_events.add);

  /// Start a broadcast session.
  Future<Room> broadcast(String broadcastToken) => _connect(broadcastToken);

  /// Start a streaming session for viewers.
  Future<Room> stream(String broadcastToken) => _connect(broadcastToken, false);

  /// Mute or unmute the local participant's microphone.
  Future<void> mute({required bool enabled}) async {
    await room.localParticipant?.setMicrophoneEnabled(enabled);
  }

  /// Disconnects from the room, ensuring resources are freed.
  Future<void> disconnect() async {
    if (room.connectionState == ConnectionState.connected) {
      await Future.wait([room.disconnect(), removeListener()]);
    }
  }

  /// Removes the listener from the room events.
  Future<void> removeListener() async {
    await listener.cancelAll();
    room.removeListener(_setupListener);
  }

  @override
  FutureOr<void> onDispose() => dispose();

  Future<void> dispose() async {
    await disconnect();
    room.removeListener(_setupListener);
    await _events.close();
    await listener.cancelAll();
    await room.dispose();
    return;
  }
}
