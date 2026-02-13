import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// Application layer - Live Session Manager
///
/// This manager:
/// - Coordinates LiveKit connection
/// - Manages broadcast/streaming session
/// - Handles reconnection logic
/// - Syncs socket events with LiveKit state
/// - Provides global session state
///
/// Lives in the live session scope (created/destroyed per broadcast)
final class LiveSessionManager with MenoLogger implements Disposable {
  LiveSessionManager({
    required Id userId,
    required BroadcastSession session,
    required IBroadcastRepository repository,
    required LiveKitClient liveKit,
  }) : _userId = userId,
       _session = session,
       _repository = repository,
       _liveKit = liveKit;

  final Id _userId;
  final BroadcastSession _session;
  final IBroadcastRepository _repository;
  final LiveKitClient _liveKit;

  // #####################################################################
  // STATES
  // #####################################################################

  late final sessionState = ValueNotifier(const LiveSession.initializing());
  late final liveStatus = ValueNotifier(LiveStatus.initializing);
  late final isMicrophoneEnabled = ValueNotifier<bool>(false);

  // #####################################################################
  // SUBSCRIPTIONS AND LISTENERS
  // #####################################################################

  StreamSubscription<LiveKitState>? _liveKitStateSubscription;
  StreamSubscription<EndedBroadcast>? _endedBroadcastSubscription;
  StreamSubscription<dynamic>? _hostDisconnectedSubscription;
  StreamSubscription<dynamic>? _hostReconnectedSubscription;

  void _setupListeners() {
    // Listen to LiveKit connection state changes
    _liveKitStateSubscription = _liveKit.connectionState.listen(
      _handleLiveKitStateChange,
      onError: (dynamic error) {
        log.e('LiveSessionManager: LiveKit state error - $error');
        if (error is LiveKitFailure) throw MenoException(error.message);
        throw MenoException(error.toString());
      },
    );

    // Listen to socket events for host disconnection
    _hostDisconnectedSubscription = _repository.onHostDisconnected.listen(
      _handleHostDisconnected,
      onError: (dynamic error) {
        log.e('LiveSessionManager: Host disconnected event error - $error');
        if (error is MenoException) throw error;
        throw MenoException(error.toString());
      },
    );

    // Listen to socket events for host reconnection
    _hostReconnectedSubscription = _repository.onHostReconnected.listen(
      _handleHostReconnected,
      onError: (dynamic error) {
        log.e('LiveSessionManager: Host reconnected event error - $error');
        if (error is MenoException) throw error;
        throw MenoException(error.toString());
      },
    );

    // Listen for broadcast ended event
    _endedBroadcastSubscription = _repository.onBroadcastEnded.listen(
      _handleBroadcastEnded,
      onError: (dynamic error) {
        log.e('LiveSessionManager: Ended broadcast event error - $error');
        if (error is MenoException) throw error;
        throw MenoException(error.toString());
      },
    );
  }

  // #####################################################################
  // PRIVATE VALUES
  // #####################################################################

  bool _isHost = false;
  Timer? _reconnectionTimer;
  int _reconnectionAttempts = 0;
  static const int _maxReconnectionAttempts = 5;

  // #####################################################################
  // COMMANDS
  // #####################################################################

  late final startSession = Command.createSyncNoParamNoResult(() async {
    final broadcast = _session.broadcast;
    log.i('LiveSessionManager: Initializing broadcast: ${broadcast.id}');

    sessionState.value = const LiveSession.initializing();
    liveStatus.value = LiveStatus.initializing;

    // Determine if user is broadcaster or listener
    _isHost = broadcast.effectiveCreatorId == _userId;

    log.i('LiveSessionManager: User is a ${_isHost ? 'host' : 'listener'}');

    // Connect to LiveKit SDK Client
    await _connectToLiveKit();

    // Emit socket event for started broadcast if broadcaster
    if (_isHost && broadcast.isActive) await _notifyBroadcastStarted();
  }, errorFilterFn: menoExceptionFilter);

  late final endSession = Command.createSyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Ending session');

    liveStatus.value = LiveStatus.disconnecting;

    final broadcastId = _session.broadcast.id;

    final result = await switch (_isHost) {
      true => _repository.emitEndBroadcast(broadcastId),
      false => _repository.emitLeaveBroadcast(broadcastId),
    };

    return result.fold(
      (failure) {
        log.e('LiveSessionManager: Failed to end broadcast - $failure');
        throw failure;
      },
      (_) async {
        log.i('LiveSessionManager: Broadcast ended on server');
        // Disconnect from LiveKit
        await _liveKit.disconnect();

        // Clear session
        await _repository.clearActiveBroadcast(_userId);

        sessionState.value = const LiveSession.ended();
        liveStatus.value = LiveStatus.offAir;

        log.i('LiveSessionManager: Session ended successfully');
      },
    );
  }, errorFilterFn: menoExceptionFilter)..errors.listen(_killOnError);

  late final toggleMicrophone = Command.createSyncNoParamNoResult(() async {
    final previousState = isMicrophoneEnabled.value;

    final newState = !isMicrophoneEnabled.value;
    isMicrophoneEnabled.value = newState;

    log.i('LiveSessionManager: Toggling microphone to $newState');

    final result = await _liveKit.setMicrophoneEnabled(newState);

    result.fold((failure) {
      log.e('LiveSessionManager: Failed to toggle microphone - $failure');
      isMicrophoneEnabled.value = previousState;
      throw MenoException(failure.message);
    }, (_) => log.i('LiveSessionManager: Microphone toggled successfully'));
  }, errorFilterFn: menoExceptionFilter);

  late final reconnectToSocket = Command.createSyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Socket reconnected, syncing state');
    // If we're a broadcaster and LiveKit is connected, notify server again
    if (_isHost && _liveKit.connected) await _notifyBroadcastStarted();
  }, errorFilterFn: menoExceptionFilter);

  // ######################################################################
  // PRIVATE METHODS
  // ######################################################################

  Future<void> _connectToLiveKit() async {
    try {
      log.i('LiveSessionManager: Connecting to LiveKit');
      liveStatus.value = LiveStatus.connecting;

      final broadcastToken = _session.broadcast.broadcastToken;
      if (broadcastToken == null) {
        log.e('LiveSessionManager: Broadcast token is null');
        throw Exception('No valid broadcast token found.');
      }

      final result = await switch (_isHost) {
        true => _liveKit.broadcast(broadcastToken),
        false => _liveKit.stream(broadcastToken),
      };

      result.fold(
        (e) {
          log.e('LiveSessionManager: LiveKit connection failed - $e');
          sessionState.value = LiveSession.error(e.message);
          liveStatus.value = LiveStatus.offAir;

          // Retry connection for certain failures
          if (e is LiveKitConnectionTimeout || e is LiveKtiConnectionFailed) {
            _scheduleReconnection();
          }
        },
        (_) {
          log.i('LiveSessionManager: LiveKit connected successfully');

          sessionState.value = switch (_isHost) {
            true => const LiveSession.broadcasting(),
            false => const LiveSession.listening(),
          };

          liveStatus.value = LiveStatus.live;

          // Reset reconnection attempts on success
          _reconnectionAttempts = 0;

          // Update microphone state
          isMicrophoneEnabled.value = _liveKit.isMicrophoneEnabled;

          // Update participant count
          // participantCount.value = _liveKit.participantCount;
        },
      );
    } catch (e) {
      log.e('LiveSessionManager: Failed to connect to LiveKit - $e');
    }
  }

  void _handleLiveKitStateChange(LiveKitState state) {
    log.d('LiveSessionManager: LiveKit state changed to $state');

    switch (state) {
      case LiveKitState.connected:
        liveStatus.value = LiveStatus.live;
        _reconnectionAttempts = 0;
        _reconnectionTimer?.cancel();

      case LiveKitState.connecting:
        liveStatus.value = LiveStatus.connecting;

      case LiveKitState.reconnecting:
        liveStatus.value = LiveStatus.reconnecting;

      case LiveKitState.disconnected:
        liveStatus.value = LiveStatus.disconnected;
        // Auto-reconnect if session is still active
        if (sessionState.value is! LiveSessionError) {
          _scheduleReconnection();
        }
    }
  }

  void _handleHostDisconnected(dynamic data) {
    // Only relevant for listeners
    if (_isHost) return;

    log.w('LiveSessionManager: Host disconnected from broadcast');
    liveStatus.value = .hostDisconnected;
    sessionState.value = const .hostDisconnected();
  }

  void _handleHostReconnected(dynamic data) {
    // Only relevant for listeners
    if (_isHost) return;

    log.i('LiveSessionManager: Host reconnected to broadcast');
    liveStatus.value = .live;

    // Restore previous state
    sessionState.value = const .listening();
  }

  Future<void> _handleBroadcastEnded(EndedBroadcast data) async {
    log.i('LiveSessionManager: Broadcast ended by host');
    sessionState.value = const .ended();
    liveStatus.value = .offAir;

    // Clean up session
    await _repository.clearActiveBroadcast(_userId);
  }

  Future<void> _notifyBroadcastStarted() async {
    try {
      log.i('LiveSessionManager: Notifying server that broadcast started');

      // Emit socket event
      if (_isHost) {
        await _repository.emitStartedBroadcast(_session.broadcast.id);
      } else {
        await _repository.emitJoinedBroadcast(_session.broadcast.id);
      }

      log.i('LiveSessionManager: Broadcast started notification sent');
    } catch (e) {
      log.e('LiveSessionManager: Failed to notify broadcast started - $e');
      // Non-critical error, continue anyway
    }
  }

  void _scheduleReconnection() {
    if (_reconnectionAttempts >= _maxReconnectionAttempts) {
      log.e('LiveSessionManager: Max reconnection attempts reached, giving up');
      sessionState.value = const LiveSession.error(
        'Connection lost. Please restart the broadcast.',
      );
      liveStatus.value = LiveStatus.offAir;
      return;
    }

    _reconnectionAttempts++;
    final delay = Duration(seconds: _reconnectionAttempts * 2);

    log.f(
      '''LiveSessionManager: Scheduling reconnection attempt $_reconnectionAttempts in ${delay.inSeconds}s''',
    );

    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(delay, () async {
      log.i('LiveSessionManager: Attempting reconnection');
      await _connectToLiveKit();
    });
  }

  void _killOnError(CommandError<void>? error, ListenableSubscription _) {
    final e = error?.error;
    log.e('LiveSessionManager: Error ending session - $e');
    sessionState.value = LiveSession.error(e.toString());
    liveStatus.value = LiveStatus.offAir;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('LiveSessionManager: Disposing');

    // Cancel timers
    _reconnectionTimer?.cancel();

    // Cancel subscriptions
    await _liveKitStateSubscription?.cancel();
    await _endedBroadcastSubscription?.cancel();
    await _hostDisconnectedSubscription?.cancel();
    await _hostReconnectedSubscription?.cancel();

    // Dispose notifiers
    sessionState.dispose();
    liveStatus.dispose();
    isMicrophoneEnabled.dispose();

    // Dispose commands
    startSession.dispose();
    endSession.dispose();
    toggleMicrophone.dispose();
    reconnectToSocket.dispose();

    log.d('LiveSessionManager: Disposed');
  }
}

// #########################################################################
// LIVE SESSION STATE
// #########################################################################

sealed class LiveSession {
  const LiveSession();

  const factory LiveSession.initializing() = LiveSessionInitializing;

  const factory LiveSession.broadcasting() = LiveSessionBroadcasting;

  const factory LiveSession.listening() = LiveSessionListening;

  const factory LiveSession.hostDisconnected() = LiveSessionHostDisconnected;

  const factory LiveSession.ended() = LiveSessionEnded;

  const factory LiveSession.error(String message) = LiveSessionError;
}

final class LiveSessionInitializing extends LiveSession {
  const LiveSessionInitializing();
}

final class LiveSessionBroadcasting extends LiveSession {
  const LiveSessionBroadcasting();
}

final class LiveSessionListening extends LiveSession {
  const LiveSessionListening();
}

final class LiveSessionHostDisconnected extends LiveSession {
  const LiveSessionHostDisconnected();
}

final class LiveSessionEnded extends LiveSession {
  const LiveSessionEnded();
}

final class LiveSessionError extends LiveSession {
  const LiveSessionError(this.message);

  final String message;
}

// #########################################################################
// LIVE STATUS ENUM
// #########################################################################

/// Global connection status
enum LiveStatus {
  initializing,
  connecting,
  live,
  reconnecting,
  disconnected,
  hostDisconnected,
  disconnecting,
  offAir,
}

/// Extension for user-friendly labels
extension LiveStatusX on LiveStatus {
  String get name {
    return switch (this) {
      .initializing => 'Initializing...',
      .connecting => 'Connecting...',
      .live => 'Live',
      .reconnecting => 'Reconnecting...',
      .disconnected => 'Disconnected',
      .hostDisconnected => 'Host Disconnected',
      .disconnecting => 'Ending...',
      .offAir => 'Off Air',
    };
  }

  bool get isActive => this == .live;

  bool get showReconnecting => this == .reconnecting || this == .connecting;
}
