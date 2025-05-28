import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
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

  Future<Either<BroadcastException, Unit>> _connect({
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
        microphone: TrackOption(enabled: isHost),
      );

      log('Connecting...');
      await room.connect(
        url,
        token,
        fastConnectOptions: isHost ? fastConnectOptions : null,
      );

      return right(unit);
    } on LiveKitException catch (e) {
      log('LiveKit: Connection failed.', error: e.message);
      await disconnect();
      if (e.message.contains('invalid token')) {
        return left(
          const BroadcastExceptionWithMessage(
            'Invalid Token: Unable to connect due to invalid token.',
          ),
        );
      }
      return left(BroadcastExceptionWithMessage(e.message));
    }
  }

  /// Mute or unmute the local participant's microphone.
  Future<void> enableMicrophone([bool enabled = true]) async {
    await room.localParticipant?.setMicrophoneEnabled(enabled);
  }

  /// Start a broadcast session.
  Future<Either<BroadcastException, Unit>> broadcast(String token) =>
      _connect(token: token, isHost: true);

  /// Start a streaming session for viewers.
  Future<Either<BroadcastException, Unit>> stream(String token) =>
      _connect(token: token);

  /// Sets up the event listener for the room.
  void _setupListener() => listener.listen(_events.add);

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
