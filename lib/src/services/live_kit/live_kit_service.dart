import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:rxdart/rxdart.dart';

export 'package:livekit_client/livekit_client.dart';

@lazySingleton
class LiveKitService extends Object with Disposable {
  final room = Room();

  late EventsListener<RoomEvent> listener;

  late BehaviorSubject<RoomEvent> _events;

  Stream<RoomEvent> get eventsStream => _events.stream.asBroadcastStream();

  Future<Either<LiveKitException, Unit>> _connect({
    required String token,
    bool isHost = false,
  }) async {
    if (room.connectionState == ConnectionState.connected) {
      await room.disconnect();
    }
    _events = BehaviorSubject<RoomEvent>();
    listener = room.createListener();
    _setupListener();
    try {
      await room.connect(Env.menoLiveKitUrl, token);
      await room.localParticipant?.setMicrophoneEnabled(isHost);
      return right(unit);
    } on LiveKitException catch (e) {
      return left(e);
    }
  }

  /// Start a broadcast session.
  Future<Either<LiveKitException, Unit>> broadcast(String token) =>
      _connect(token: token, isHost: true);

  /// Start a streaming session for viewers.
  Future<Either<LiveKitException, Unit>> stream(String token) =>
      _connect(token: token);

  /// Sets up the event listener for the room.
  void _setupListener() => listener.listen(_events.add);

  /// Mute or unmute the local participant's microphone.
  Future<void> mute({required bool enabled}) async {
    await room.localParticipant?.setMicrophoneEnabled(enabled);
  }

  /// Disconnects from the room, ensuring resources are freed.
  Future<void> disconnect() async {
    await Future.wait([room.disconnect(), removeListener()]);
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
