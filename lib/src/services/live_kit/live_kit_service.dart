import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:rxdart/rxdart.dart';

export 'package:livekit_client/livekit_client.dart';

@lazySingleton
class LiveKitService extends Object with Disposable {
  final room = Room();

  late EventsListener<RoomEvent> listener;

  late BehaviorSubject<RoomEvent> _events;

  Stream<RoomEvent> get eventsStream => _events.stream.asBroadcastStream();

  Future<Either<LiveKitException, Unit>> _connectFamily({
    required String token,
    bool isHost = false,
  }) async {
    await room.disconnect();

    _events = BehaviorSubject<RoomEvent>();

    listener = room.createListener();
    _setupListener();

    try {
      await room.prepareConnection(Env.menoLiveKitUrl, token);
      await room.connect(
        Env.menoLiveKitUrl,
        token,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(enabled: isHost),
        ),
      );

      return right(unit);
    } on LiveKitException catch (e) {
      return left(e);
    }
  }

  /// Start a broadcast session.
  Future<Either<LiveKitException, Unit>> broadcast2(String token) =>
      _connectFamily(token: token, isHost: true);

  /// Start a streaming session for viewers.
  Future<Either<LiveKitException, Unit>> stream2(String token) =>
      _connectFamily(token: token);

  Future<Room> _connect(String broadcastToken, [bool isHost = true]) async {
    // Create a new room
    _events = BehaviorSubject<RoomEvent>();

    // Set a Listener for the Room Events before connecting
    listener = room.createListener(synchronized: true);
    _setupListener();

    try {
      // Connect to the room
      await room.connect(
        Env.menoLiveKitUrl,
        broadcastToken,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(enabled: isHost),
        ),
      );

      return room; // Return the connected room
    } catch (e) {
      await removeListener();
      throw Exception('Failed to connect. Please try again. => $e');
    }
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
