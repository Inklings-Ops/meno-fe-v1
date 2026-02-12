import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:livekit_client/livekit_client.dart' as sdk;
import 'package:meno/core/core.dart';

/// Infrastructure layer - LiveKit Client
///
/// Manages LiveKit room connection and audio/video streaming.
/// This is a low-level infrastructure component that should NOT be
/// exposed to the application layer directly.
final class LiveKitClient with MenoLogger implements Disposable {
  LiveKitClient({required String url}) : _url = url;

  final String _url;

  sdk.Room? _room;
  sdk.EventsListener<sdk.RoomEvent>? _listener;

  final _connectionStateCtr = StreamController<LiveKitState>.broadcast();

  Stream get connectionState => _connectionStateCtr.stream;

  final _roomEventsCtr = StreamController<sdk.RoomEvent>.broadcast();

  Stream get roomEvents => _roomEventsCtr.stream;

  final _participantEventsCtr = StreamController<ParticipantEvent>.broadcast();

  Stream get participantEvents => _participantEventsCtr.stream;

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
  // COMMANDS
  // #########################################################################

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    _room = sdk.Room(
      roomOptions: const sdk.RoomOptions(
        defaultAudioPublishOptions: sdk.AudioPublishOptions(name: 'microphone'),
        adaptiveStream: true,
        dynacast: true,
      ),
    );

    _listener = _room?.createListener();
    _setupRoomListeners();
  }, errorFilterFn: menoExceptionFilter);

  /// Connect to LiveKit room as a broadcaster (host)
  ///
  /// This enables microphone by default and prepares for broadcasting
  late final broadcast = Command.createAsyncNoResult<String>((token) async {
    final result = await _connect(token: token);
    return result.fold((failure) => throw failure, (value) => value);
  }, errorFilterFn: menoExceptionFilter);

  /// Connect to LiveKit room as a listener (viewer)
  ///
  /// Microphone is disabled by default for listeners
  late final stream = Command.createAsyncNoResult<String>((token) async {
    final result = await _connect(
      token: token,
      isBroadcaster: false,
      enableMicrophone: false,
    );
    return result.fold((failure) => throw failure, (value) => value);
  }, errorFilterFn: menoExceptionFilter);

  /// Disconnects from the LiveKit room
  ///
  late final disconnect = Command.createAsyncNoParamNoResult(
    _disconnect,
    errorFilterFn: menoExceptionFilter,
  );

  /// Enabled the microphone of the participant
  ///
  late final toggleMicrophone = Command.createAsync<bool, bool>(
    (enabled) async {
      final result = await _enableMicrophone(enabled);
      return result.fold((failure) => throw failure, (value) => value);
    },
    initialValue: false,
    errorFilterFn: menoExceptionFilter,
  );

  /// Reconnect with the same configuration
  ///
  late final reconnect = Command.createAsyncNoResult<String>((token) async {
    final result = await _reconnect(token);
    return result.fold((failure) => throw failure, (value) => value);
  }, errorFilterFn: menoExceptionFilter);

  // #########################################################################
  // HELPER METHODS
  // #########################################################################

  Future<Either<MenoException, Unit>> _connect({
    required String token,
    bool enableMicrophone = true,
    bool isBroadcaster = true,
  }) async {
    try {
      // Disconnect if already connected
      if (_room?.connectionState == sdk.ConnectionState.connected) {
        log.w('LiveKit: Already connected, disconnecting first');
        await _disconnect();
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
      if (isBroadcaster) {
        fastConnectOptions = sdk.FastConnectOptions(
          microphone: sdk.TrackOption(enabled: enableMicrophone),
        );
      }

      log.i(
        'LiveKit: Connecting as ${isBroadcaster ? 'broadcaster' : 'listener'}',
      );

      // Connect to room
      await _room!.connect(_url, token, fastConnectOptions: fastConnectOptions);

      log.i('LiveKit: Connected successfully');
      return const Right(unit);
    } on sdk.LiveKitException catch (e) {
      log.e('LiveKit: Connection failed - ${e.message}');
      await _disconnect();
      return Left(MenoException(e.message));
    } catch (e) {
      log.e('LiveKit: Unexpected error - $e');
      await _disconnect();
      return Left(MenoException(e.toString()));
    }
  }

  /// Disconnect from room
  Future<void> _disconnect() async {
    try {
      log.i('LiveKit: Disconnecting from room');
      _updateConnectionState(.disconnected);

      await _room?.disconnect();
      log.i('LiveKit: Disconnected successfully');
    } catch (e) {
      log.e('LiveKit: Error during disconnect - $e');
      throw MenoException(e.toString());
    }
  }

  /// Reconnect with the same configuration
  Future<Either<MenoException, Unit>> _reconnect(String token) async {
    try {
      log.i('LiveKit: Attempting to reconnect');
      _updateConnectionState(.reconnecting);

      await _room!.connect(_url, token);

      log.i('LiveKit: Reconnected successfully');
      return const Right(unit);
    } catch (e) {
      log.e('LiveKit: Reconnection failed - $e');
      return Left(MenoException(e.toString()));
    }
  }

  /// Enable or disable local microphone
  Future<Either<MenoException, bool>> _enableMicrophone(bool enabled) async {
    try {
      if (_room?.localParticipant == null) {
        return const Left(MenoException('Failed: Not connected to room'));
      }

      await _room!.localParticipant!.setMicrophoneEnabled(enabled);
      log.i('LiveKit: Microphone ${enabled ? 'enabled' : 'disabled'}');
      return Right(enabled);
    } catch (e) {
      log.e('LiveKit: Failed to set microphone state - $e');
      return Left(MenoException(e.toString()));
    }
  }

  /// Setup all room event listeners
  void _setupRoomListeners() {
    if (_listener == null) return;

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

  /// Handle specific room events
  void _handleRoomEvent(sdk.RoomEvent event) {
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
        _participantEventsCtr.add(.connected(participant));
        log.i('LiveKit: Participant connected - ${participant.identity}');

      case sdk.ParticipantDisconnectedEvent(:final participant):
        _participantEventsCtr.add(.disconnected(participant));
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
      await _room?.disconnect();
      await _room?.dispose();
      _room = null;

      // Close commands
      initialize.dispose();
      broadcast.dispose();
      stream.dispose();
      disconnect.dispose();
      toggleMicrophone.dispose();
      reconnect.dispose();

      // Close streams
      await _connectionStateCtr.close();
      await _roomEventsCtr.close();
      await _participantEventsCtr.close();

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
// PARTICIPANT EVENTS
// #########################################################################

sealed class ParticipantEvent {
  const ParticipantEvent();

  factory ParticipantEvent.connected(sdk.Participant participant) {
    return ParticipantConnected(participant);
  }

  factory ParticipantEvent.disconnected(sdk.Participant participant) {
    return ParticipantDisconnected(participant);
  }
}

final class ParticipantConnected extends ParticipantEvent {
  const ParticipantConnected(this.participant);

  final sdk.Participant participant;
}

final class ParticipantDisconnected extends ParticipantEvent {
  const ParticipantDisconnected(this.participant);

  final sdk.Participant participant;
}
