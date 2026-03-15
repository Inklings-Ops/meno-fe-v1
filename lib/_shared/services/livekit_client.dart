import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:livekit_client/livekit_client.dart' as sdk;
import 'package:meno/_core/meno_logger.dart';

/// Infrastructure layer - LiveKit Client
///
/// Manages LiveKit room connection and audio/video streaming.
/// This is a low-level infrastructure component that should NOT be
/// exposed to the application layer directly.
class LiveKitClient with MLogger implements Disposable {
  LiveKitClient._(this._url);

  final String _url;

  sdk.Room? _room;
  sdk.EventsListener<sdk.RoomEvent>? _listener;

  final _connectionStateCtr = StreamController<LiveKitState>.broadcast();

  Stream<LiveKitState> get connectionState => _connectionStateCtr.stream;

  final _roomEventsCtr = StreamController<sdk.RoomEvent>.broadcast();

  Stream<sdk.RoomEvent> get roomEvents => _roomEventsCtr.stream;

  /// Current connection state
  LiveKitState _currentState = LiveKitState.disconnected;

  LiveKitState get currentState => _currentState;

  /// Check if connected
  bool get connected => _room?.connectionState == sdk.ConnectionState.connected;

  /// Get the local participant
  sdk.LocalParticipant? get localParticipant => _room?.localParticipant;

  /// Get current microphone state
  bool get isMicrophoneEnabled {
    final track = _room?.localParticipant?.audioTrackPublications.firstOrNull;
    return track?.muted == false;
  }

  // #########################################################################
  // ACTIONS
  // #########################################################################

  static LiveKitClient initialize(String url) {
    final client = LiveKitClient._(url);
    client.log.i('LiveKit: Initializing client');
    client._room = sdk.Room(
      roomOptions: const sdk.RoomOptions(
        defaultAudioPublishOptions: sdk.AudioPublishOptions(name: 'microphone'),
        adaptiveStream: true,
        dynacast: true,
      ),
    );

    client._listener = client._room?.createListener();
    client._setupRoomListeners();
    client.log.i('LiveKit: Client initialized successfully');
    return client;
  }

  /// Connect to LiveKit room as a broadcaster (host)
  ///
  /// This enables microphone by default and prepares for broadcasting
  Future<Either<LiveKitFailure, Unit>> broadcast(String token) async {
    return _connect(token: token, enableMicrophone: true, isHost: true);
  }

  /// Connect to LiveKit room as a listener (viewer)
  ///
  /// Microphone is disabled by default for listeners
  Future<Either<LiveKitFailure, Unit>> stream(String token) async {
    return _connect(token: token, enableMicrophone: false, isHost: false);
  }

  /// Disconnects from the LiveKit room
  ///
  /// Disconnect from room
  Future<void> disconnect() async {
    try {
      log.i('LiveKit: Disconnecting from room');
      _updateConnectionState(.disconnected);

      await _room?.disconnect();
      log.i('LiveKit: Disconnected successfully');
    } catch (e) {
      log.e('LiveKit: Error during disconnect - $e');
      throw LiveKitUnexpectedError(e.toString());
    }
  }

  /// Enable or disable local microphone
  Future<Either<LiveKitFailure, bool>> setMicrophoneEnabled(
    bool enabled,
  ) async {
    try {
      if (_room?.localParticipant == null) {
        return const Left(LiveKitNotConnected());
      }

      await _room!.localParticipant!.setMicrophoneEnabled(enabled);
      log.i('LiveKit: Microphone ${enabled ? 'enabled' : 'disabled'}');
      return Right(enabled);
    } catch (e) {
      log.e('LiveKit: Failed to set microphone state - $e');
      return Left(LiveKitMicError(e.toString()));
    }
  }

  /// Reconnect with the same configuration
  Future<Either<LiveKitFailure, Unit>> reconnect(String token) async {
    try {
      log.i('LiveKit: Attempting to reconnect');
      _updateConnectionState(.reconnecting);

      await _room!.connect(_url, token);

      log.i('LiveKit: Reconnected successfully');
      return const Right(unit);
    } catch (e) {
      log.e('LiveKit: Reconnection failed - $e');
      return Left(LiveKitReconnectFailed(e.toString()));
    }
  }

  // #########################################################################
  // HELPER METHODS
  // #########################################################################

  Future<Either<LiveKitFailure, Unit>> _connect({
    required String token,
    required bool enableMicrophone,
    required bool isHost,
  }) async {
    try {
      // Disconnect if already connected
      if (_room?.connectionState == sdk.ConnectionState.connected) {
        log.w('LiveKit: Already connected, disconnecting first');
        await disconnect();
        // Wait a bit for cleanup
        await Future.delayed(const Duration(milliseconds: 500));
      }

      _updateConnectionState(.connecting);
      log.i('LiveKit: Preparing connection to $_url');

      // Prepare connection
      await _room!.prepareConnection(_url, token);
      log.i('LiveKit: Connection prepared');

      // Configure fast connect options for broadcaster
      sdk.FastConnectOptions? fastConnectOptions;
      if (isHost) {
        fastConnectOptions = sdk.FastConnectOptions(
          microphone: sdk.TrackOption(enabled: enableMicrophone),
        );
      }

      log.i('LiveKit: Connecting as ${isHost ? 'broadcaster' : 'listener'}');

      // Connect to room
      await _room!.connect(_url, token, fastConnectOptions: fastConnectOptions);

      log.i('LiveKit: Connected successfully');
      return const Right(unit);
    } on sdk.LiveKitException catch (e) {
      log.e('LiveKit: Connection failed - ${e.message}');
      await disconnect();

      if (e.message.contains('invalid token')) {
        return const Left(LiveKitInvalidToken());
      }

      if (e.message.contains('timeout')) {
        return const Left(LiveKitConnectionTimeout());
      }

      return Left(LiveKtiConnectionFailed(e.message));
    } catch (e) {
      log.e('LiveKit: Unexpected error - $e');
      await disconnect();
      return Left(LiveKitUnexpectedError(e.toString()));
    }
  }

  /// Setup all room event listeners
  void _setupRoomListeners() {
    if (_listener == null) return;

    log.i('LiveKit: Setting up room listeners');

    // Forward all events to the room events stream
    _listener!.listen((event) {
      _roomEventsCtr.add(event);
      _handleRoomEvent(event);
    });
  }

  void _updateConnectionState(LiveKitState state) {
    if (_currentState != state) {
      _currentState = state;
      _connectionStateCtr.add(state);
    }
  }

  /// Removes the listener from the room events.
  Future<void> removeListener() async {
    await _listener?.cancelAll();
    _room?.removeListener(_setupRoomListeners);
  }

  /// Handle specific room events
  void _handleRoomEvent(sdk.RoomEvent event) {
    log.e('LiveKit: Room Event (${event.runtimeType}): $event');

    switch (event) {
      case sdk.RoomConnectedEvent():
        _updateConnectionState(.connected);
        log.i('LiveKit: Room connected');

      case sdk.RoomDisconnectedEvent(:final reason):
        _updateConnectionState(.disconnected);
        log.w('LiveKit: Room disconnected - $reason');

      case sdk.RoomReconnectingEvent():
        _updateConnectionState(.reconnecting);
        log.f('LiveKit: Reconnecting...');

      case sdk.RoomReconnectedEvent():
        _updateConnectionState(.connected);
        log.i('LiveKit: Reconnected successfully');

      case sdk.ParticipantConnectedEvent(:final participant):
        log.i('LiveKit: Participant connected - ${participant.identity}');

      case sdk.ParticipantDisconnectedEvent(:final participant):
        log.i('LiveKit: Participant disconnected - ${participant.identity}');

      case sdk.TrackPublishedEvent(:final participant):
        log.d('LiveKit: Track published by ${participant.identity}');

      case sdk.TrackUnpublishedEvent(:final participant):
        log.d('LiveKit: Track unpublished by ${participant.identity}');

      case sdk.TrackSubscribedEvent(:final participant):
        log.d('LiveKit: Track subscribed from ${participant.identity} ');

      case sdk.TrackUnsubscribedEvent(:final participant):
        log.d('LiveKit: Track unsubscribed from ${participant.identity} ');

      default:
        break;
    }
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('LiveKit: Disposing client');

    try {
      // Cancel listener
      await _listener?.cancelAll();
      _listener = null;

      // Disconnect from room
      _room?.removeListener(_setupRoomListeners);
      await _room?.disconnect();
      await _room?.dispose();
      _room = null;

      // Close streams
      await _connectionStateCtr.close();
      await _roomEventsCtr.close();

      log.d('LiveKit: Client disposed successfully');
    } catch (e) {
      log.e('LiveKit: Error during disposal - $e');
    }
  }
}

// #########################################################################
// LIVEKIT CONNECTION STATE
// #########################################################################

enum LiveKitState { disconnected, connecting, connected, reconnecting }

extension LivekitConnectionStateX on sdk.ConnectionState {
  LiveKitState get toLiveKitState => switch (this) {
    .disconnected => LiveKitState.disconnected,
    .connecting => LiveKitState.connecting,
    .connected => LiveKitState.connected,
    .reconnecting => LiveKitState.reconnecting,
  };
}

// #########################################################################
// LIVEKIT FAILURES
// #########################################################################

sealed class LiveKitFailure implements Exception {
  const LiveKitFailure(this.message);

  final String message;
}

final class LiveKitInvalidToken extends LiveKitFailure {
  const LiveKitInvalidToken([
    super.message = 'Unable to connect: Invalid or expired token',
  ]);
}

final class LiveKitConnectionTimeout extends LiveKitFailure {
  const LiveKitConnectionTimeout([
    super.message = 'Connection timeout: Please check your internet connection',
  ]);
}

final class LiveKtiConnectionFailed extends LiveKitFailure {
  const LiveKtiConnectionFailed(super.message);
}

final class LiveKitReconnectFailed extends LiveKitFailure {
  const LiveKitReconnectFailed(super.message);
}

final class LiveKitNotConnected extends LiveKitFailure {
  const LiveKitNotConnected([super.message = 'Failed: Not connected to room']);
}

final class LiveKitMicError extends LiveKitFailure {
  const LiveKitMicError(super.message);
}

final class LiveKitUnexpectedError extends LiveKitFailure {
  const LiveKitUnexpectedError(super.message);
}
