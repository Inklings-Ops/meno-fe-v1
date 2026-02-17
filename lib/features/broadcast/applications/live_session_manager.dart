import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
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
class LiveSessionManager with MLogger implements Disposable, WillSignalReady {
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

  // Timer manager
  late final LiveTimerManager timer;

  // #####################################################################
  // STATES
  // #####################################################################

  late final sessionState = ValueNotifier(const LiveSession.initializing());
  late final liveStatus = ValueNotifier(LiveStatus.initializing);
  late final isMicrophoneEnabled = ValueNotifier<bool>(false);

  // #####################################################################
  // EXPOSED STATES
  // #####################################################################

  Broadcast get broadcast => _session.broadcast;

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

  late final initializeTimer = Command.createAsyncNoParamNoResult(() async {
    // Get broadcast start time from session
    final startTime = _session.broadcast.startTime;

    if (startTime == null) {
      log.e('LiveTimerManager: No start time available');
      // Fallback to session timestamp
      timer = LiveTimerManager(broadcastStartTime: _session.timestamp);
      return;
    }

    // For zombie recovery, we might have cached elapsed time
    // Calculate it from start time
    final now = DateTime.now();
    final calculatedElapsed = now.difference(startTime);

    timer = LiveTimerManager(
      broadcastStartTime: startTime,
      initialElapsed: calculatedElapsed,
    );

    log.i('LiveTimerManager: Initialized with start time $startTime');
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(startSession);

  late final startSession = Command.createAsyncNoParamNoResult(() async {
    final broadcast = _session.broadcast;
    log.i('LiveSessionManager: Initializing broadcast: ${broadcast.id}');

    sessionState.value = const LiveSession.initializing();
    liveStatus.value = LiveStatus.initializing;

    // Determine if user is broadcaster or listener
    _isHost = broadcast.effectiveCreatorId == _userId;

    log.i('LiveSessionManager: User is a ${_isHost ? 'host' : 'listener'}');
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(connectToLiveKit);

  late final connectToLiveKit = Command.createAsyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Connecting to LiveKit');
    liveStatus.value = LiveStatus.connecting;

    final broadcastToken = _session.broadcast.broadcastToken;
    if (broadcastToken == null) {
      log.e('LiveSessionManager: Broadcast token is null');
      throw const MenoException('No valid broadcast token found.');
    }

    final result = await switch (_isHost) {
      true => _liveKit.broadcast(broadcastToken),
      false => _liveKit.stream(broadcastToken),
    };

    return result.fold(
      (e) {
        log.e('LiveSessionManager: LiveKit connection failed - $e');
        sessionState.value = LiveSession.error(e.message);
        liveStatus.value = LiveStatus.offAir;

        // Retry connection for certain failures
        if (e is LiveKitConnectionTimeout || e is LiveKtiConnectionFailed) {
          _scheduleReconnection();
        }

        throw MenoException(e.message);
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

        // Start timer once connected successfully
        timer.start.run();
      },
    );
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(emitStartedEvent);

  late final emitStartedEvent = Command.createAsyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Notifying server that broadcast started');

    final broadcastId = _session.broadcast.id;

    // Emit socket event
    if (_isHost) {
      await _repository.emitStartedBroadcast(broadcastId);
      await _repository.deleteDraft(userId: _userId, draftId: broadcastId);
    } else {
      await _repository.emitJoinedBroadcast(broadcastId);
    }

    // ✅ Signal GetIt that the full pipeline is complete and this manager
    // is truly ready. Any awaiter of di.isReady<LiveSessionManager>()
    // will now unblock.
    GetIt.instance.signalReady(this);
    log.i('LiveSessionManager: Session is fully live and ready');
  }, errorFilterFn: menoExceptionFilter);

  late final endSession = Command.createAsyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Ending session');

    liveStatus.value = LiveStatus.disconnecting;

    final broadcastId = _session.broadcast.id;

    // Stop timer
    timer.stop.run();
    log.i('LiveSessionManager: Timer stopped - ${timer.currentElapsed}');
    log.i('LiveSessionManager: BQS: ${timer.qualityScore.toStringAsFixed(1)}%');

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

  late final toggleMicrophone = Command.createAsyncNoResult((bool value) async {
    final previousState = isMicrophoneEnabled.value;
    isMicrophoneEnabled.value = value;

    log.i('LiveSessionManager: Toggling microphone to $value');

    final result = await _liveKit.setMicrophoneEnabled(value);

    result.fold((failure) {
      log.e('LiveSessionManager: Failed to toggle microphone - $failure');
      isMicrophoneEnabled.value = previousState;
      throw MenoException(failure.message);
    }, (_) => log.i('LiveSessionManager: Microphone toggled successfully'));
  }, errorFilterFn: menoExceptionFilter);

  late final reconnectToSocket = Command.createAsyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Socket reconnected, syncing state');
    // If we're a broadcaster and LiveKit is connected, notify server again
    if (_isHost && _liveKit.connected) {
      log.i('LiveSessionManager: Notifying server that broadcast started');

      // Emit socket event
      if (_isHost) {
        await _repository.emitStartedBroadcast(_session.broadcast.id);
      } else {
        await _repository.emitJoinedBroadcast(_session.broadcast.id);
      }

      log.i('LiveSessionManager: Broadcast started notification sent');
    }
  }, errorFilterFn: menoExceptionFilter);

  // ######################################################################
  // PRIVATE METHODS
  // ######################################################################

  void _handleLiveKitStateChange(LiveKitState state) {
    log.d('LiveSessionManager: LiveKit state changed to $state');

    switch (state) {
      case LiveKitState.connected:
        liveStatus.value = LiveStatus.live;
        _reconnectionAttempts = 0;
        _reconnectionTimer?.cancel();

        // Resume timer if it was paused
        if (!timer.isRunning.value) {
          timer.resume.run();
          log.i('LiveSessionManager: Timer resumed after reconnection');
        }

      case LiveKitState.connecting:
        liveStatus.value = LiveStatus.connecting;

      case LiveKitState.reconnecting:
        liveStatus.value = LiveStatus.reconnecting;

        // Pause timer during reconnection
        if (timer.isRunning.value) {
          timer.pause.run();
          log.i('LiveSessionManager: Timer paused during reconnection');
        }

      case LiveKitState.disconnected:
        liveStatus.value = LiveStatus.disconnected;

        // Pause timer on disconnection
        if (timer.isRunning.value) {
          timer.pause.run();
          log.i('LiveSessionManager: Timer paused due to disconnection');
        }

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

    // Pause timer for listeners when host disconnects
    if (timer.isRunning.value) {
      timer.pause.run();
      log.i('LiveSessionManager: Timer paused - host disconnected');
    }
  }

  void _handleHostReconnected(dynamic data) {
    // Only relevant for listeners
    if (_isHost) return;

    log.i('LiveSessionManager: Host reconnected to broadcast');
    liveStatus.value = .live;

    // Restore previous state
    sessionState.value = const .listening();

    // Resume timer for listeners when host reconnects
    if (!timer.isRunning.value) {
      timer.resume.run();
      log.i('LiveSessionManager: Timer resumed - host reconnected');
    }
  }

  Future<void> _handleBroadcastEnded(EndedBroadcast data) async {
    log.i('LiveSessionManager: Broadcast ended by host');

    // Stop timer
    timer.stop.run();
    log.i('LiveSessionManager: Timer stopped - broadcast ended');

    sessionState.value = const .ended();
    liveStatus.value = .offAir;

    // Clean up session
    await _repository.clearActiveBroadcast(_userId);
  }

  void _scheduleReconnection() {
    if (_reconnectionAttempts >= _maxReconnectionAttempts) {
      log.e('LiveSessionManager: Max reconnection attempts reached, giving up');
      sessionState.value = const LiveSession.error(
        'Connection lost. Please restart the broadcast.',
      );
      liveStatus.value = LiveStatus.offAir;

      // Stop timer after max reconnection attempts
      timer.stop.run();
      return;
    }

    _reconnectionAttempts++;
    final delay = Duration(seconds: _reconnectionAttempts * 2);

    log.f(
      '''LiveSessionManager: Scheduling reconnection attempt $_reconnectionAttempts in ${delay.inSeconds}s''',
    );

    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(delay, () {
      log.i('LiveSessionManager: Attempting reconnection');
      connectToLiveKit.run();
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

    // Dispose timer manager
    await timer.onDispose();

    // Dispose notifiers
    sessionState.dispose();
    liveStatus.dispose();
    isMicrophoneEnabled.dispose();

    // Dispose commands
    initializeTimer.dispose();
    startSession.dispose();
    connectToLiveKit.dispose();
    emitStartedEvent.dispose();
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

  bool get isInitializing => this == .initializing || this == .connecting;

  bool get isActive => this == .live;

  bool get showReconnecting => this == .reconnecting || this == .connecting;
}
