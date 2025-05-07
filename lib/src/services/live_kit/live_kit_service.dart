import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:rxdart/rxdart.dart';

export 'package:livekit_client/livekit_client.dart';

@lazySingleton
class LiveKitService extends Object with Disposable {
  final room = Room(
    roomOptions: const RoomOptions(
      defaultAudioPublishOptions: AudioPublishOptions(
        name: 'microphone',
        audioBitrate: AudioPreset.speech,
      ),
    ),
  );

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
    final url = Env.menoLiveKitUrl;
    _events = BehaviorSubject<RoomEvent>();
    listener = room.createListener();
    _setupListener();
    try {
      log('Preparing the connection...');
      await room.prepareConnection(url, token);

      log('Connection prepared.');
      final fastConnectOptions = FastConnectOptions(
        microphone: isHost
            ? const TrackOption(enabled: true)
            : const TrackOption(enabled: false),
      );

      log('Connecting...');
      await room.connect(
        url,
        token,
        fastConnectOptions: fastConnectOptions,
      );

      if (isHost) {
        await room.localParticipant?.setMicrophoneEnabled(true);
      }
      return right(unit);
    } on LiveKitException catch (e) {
      log('LiveKit: Connection failed.', error: e);
      await disconnect();
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
