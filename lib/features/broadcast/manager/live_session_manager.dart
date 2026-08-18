import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/livekit_client.dart';
import 'package:meno/features/broadcast/manager/broadcast_timer_manager.dart';
import 'package:meno/features/broadcast/model/_model.dart';
import 'package:meno/features/broadcast/services/_services.dart';
import 'package:meno/features/profile/model/entities/profile.dart';
import 'package:meno/features/profile/model/proxies/user_profile_proxy.dart';

class LiveSessionManager with MLogger implements Disposable, WillSignalReady {
  LiveSessionManager({
    required BroadcastSession session,
    required BroadcastLocalService local,
    required BroadcastSocketService socket,
    required LiveKitClient livekit,
  }) : _session = session,
       _local = local,
       _socket = socket,
       _livekit = livekit;

  final BroadcastSession _session;
  final BroadcastLocalService _local;
  final BroadcastSocketService _socket;
  final LiveKitClient _livekit;

  late final BroadcastTimerManager timer;

  Id get _currentUserId => _session.currentUserId;

  late final broadcast = ValueNotifier<Broadcast>(_session.broadcast);
  final state = ValueNotifier<LiveSessionState>(const .initializing());
  final status = ValueNotifier<LiveStatus>(.initializing);
  final isMicrophoneEnabled = ValueNotifier<bool>(false);
  final isHost = ValueNotifier<bool>(false);
  late final hostProxy = UserProfileProxy(
    Profile(
      id: _session.broadcast.hostId,
      fullName: _session.broadcast.hostName,
      image: _session.broadcast.hostImageUrl != null
          ? ImageInput.fromUrl(_session.broadcast.hostImageUrl)
          : null,
    ),
  );

  StreamSubscription<LiveKitState>? _liveKitStateSubscription;
  StreamSubscription<EndedBroadcast>? _endedBroadcastSubscription;
  StreamSubscription<dynamic>? _hostDisconnectedSubscription;
  StreamSubscription<dynamic>? _hostReconnectedSubscription;

  // bool isHost.value = false;
  Timer? _reconnectionTimer;
  int _reconnectionAttempts = 0;
  static const int _maxReconnectionAttempts = 5;

  late final setupConfigs = Command.createSyncNoParamNoResult(() {
    final startTime = _session.broadcast.startTime;

    if (startTime == null) {
      timer = BroadcastTimerManager(broadcastStartTime: _session.timestamp);
    } else {
      final calculatedElapsedTime = DateTime.now().difference(startTime);
      timer = BroadcastTimerManager(
        broadcastStartTime: startTime,
        initialElapsedTime: calculatedElapsedTime,
      );
    }

    _setupListeners();
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_initializeSession);

  late final _initializeSession = Command.createSyncNoParamNoResult(() {
    final broadcast = _session.broadcast;
    state.value = const .initializing();
    status.value = .initializing;
    isHost.value = broadcast.hostId == _currentUserId;
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_connectToLiveKit);

  late final _connectToLiveKit = Command.createAsyncNoParamNoResult(() async {
    status.value = .connecting;

    final broadcastToken = _session.broadcast.broadcastToken;
    if (broadcastToken == null) throw const NoBroadcastToken();

    await switch (isHost.value) {
      true => _livekit.broadcast(broadcastToken),
      false => _livekit.stream(broadcastToken),
    };
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_emitSocketEvent);

  late final _emitSocketEvent = Command.createAsyncNoParamNoResult(() async {
    final broadcastId = _session.broadcast.id;
    if (isHost.value) {
      await _socket.emitStartedBroadcast(broadcastId);
      await _local.deleteDraft(userId: _currentUserId, draftId: broadcastId);
    } else {
      await _socket.emitJoinedBroadcast(broadcastId);
    }
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_finalizeSession);

  late final _finalizeSession = Command.createSyncNoParamNoResult(() {
    if (isHost.value) isMicrophoneEnabled.value = _livekit.isMicrophoneEnabled;
    state.value = isHost.value ? const .broadcasting() : const .streaming();
    status.value = .live;
    _reconnectionAttempts = 0;
    timer.start.run();
    GetIt.instance.signalReady(this);
  }, errorFilterFn: menoExceptionFilter);

  late final endSession = Command.createAsyncNoParamNoResult(() async {
    status.value = .disconnecting;
    final broadcastId = _session.broadcast.id;

    timer.stop.run();
    log.i('LiveSessionManager: Timer stopped - ${timer.currentElapsed}');

    await switch (isHost.value) {
      true => _socket.emitEndBroadcast(broadcastId),
      false => _socket.emitLeaveBroadcast(broadcastId),
    };
  }, errorFilterFn: menoExceptionFilter);

  late final toggleMicrophone = Command.createUndoableNoResult<bool, bool>(
    (value, stack) async {
      stack.push(isMicrophoneEnabled.value);
      isMicrophoneEnabled.value = value;
      await _livekit.setMicrophoneEnabled(value);
    },
    undo: (stack, reason) => isMicrophoneEnabled.value = stack.pop(),
    errorFilterFn: menoExceptionFilter,
  );

  late final reconnectToSocket = Command.createAsyncNoParamNoResult(() async {
    log.i('LiveSessionManager: Socket reconnected, syncing state');
    // If we're a broadcaster and LiveKit is connected, notify server again
    if (isHost.value && _livekit.connected) {
      log.i('LiveSessionManager: Notifying server that broadcast started');

      // Emit socket event
      if (isHost.value) {
        await _socket.emitStartedBroadcast(_session.broadcast.id);
      } else {
        await _socket.emitJoinedBroadcast(_session.broadcast.id);
      }

      log.i('LiveSessionManager: Broadcast started notification sent');
    }
  }, errorFilterFn: menoExceptionFilter);

  void _setupListeners() {
    // Listen to LiveKit connection state changes
    _liveKitStateSubscription = _livekit.connectionState.listen(
      _handleLiveKitStateChange,
      onError: (dynamic error) {
        log.e('LiveSessionManager: LiveKit state error - $error');
        if (error is LiveKitFailure) throw MenoException(error.message);
        throw MenoException(error.toString());
      },
    );

    // Listen to socket events for host disconnection
    _hostDisconnectedSubscription = _socket.onHostDisconnected.listen(
      _handleHostDisconnected,
      onError: (dynamic error) {
        log.e('LiveSessionManager: Host disconnected event error - $error');
        if (error is MenoException) throw error;
        throw MenoException(error.toString());
      },
    );

    // Listen to socket events for host reconnection
    _hostReconnectedSubscription = _socket.onHostReconnected.listen(
      _handleHostReconnected,
      onError: (dynamic error) {
        log.e('LiveSessionManager: Host reconnected event error - $error');
        if (error is MenoException) throw error;
        throw MenoException(error.toString());
      },
    );

    // Listen for broadcast ended event
    _endedBroadcastSubscription = _socket.onEndedBroadcast.listen(
      _handleOnBroadcastEnded,
      onError: (dynamic error) {
        log.e('LiveSessionManager: Ended broadcast event error - $error');
        if (error is MenoException) throw error;
        throw MenoException(error.toString());
      },
    );

    // Listen for Errors on the LiveKit connection
    _connectToLiveKit.errors.listen((error, _) {
      if (error == null) return;

      final err = error.error;
      final message = errorMessage(err);
      log.e('LiveSessionManager: LiveKit connection failed - $message');
      state.value = .error(message);
      status.value = .offAir;

      // Retry connection for certain failures
      if (err is LiveKitConnectionTimeout || err is LiveKtiConnectionFailed) {
        _scheduleReconnection();
      }
    });

    // Listen for errors on the socket event emission
    _emitSocketEvent.errors.listen((error, _) {
      if (error == null) return;

      final e = error.error;
      final message = errorMessage(e);
      log.e('LiveSessionManager: Socket connection failed - $e');
      state.value = .error(message);
      status.value = .offAir;

      if (e is SocketNotConnectedException || e is SocketTimeoutException) {
        _scheduleReconnection();
      }
    });

    endSession.listen((_, __) async {
      log.i('LiveSessionManager: Session ended on server, disconnecting');
      await _livekit.disconnect();
      await _local.clearActiveBroadcastId(_currentUserId);
      state.value = const .ended();
      status.value = .offAir;

      // Tear down the live scope — disposes all scoped services and signals
      // the rest of the app (router, shell) that no session is active.
      log.i('LiveSessionManager: Popping live session scope');
    });

    endSession.errors.listen((error, _) async {
      final message = errorMessage(error?.error);

      // Still attempt to end the broadcast and dispose resources
      await _livekit.setMicrophoneEnabled(false);
      await _livekit.disconnect();
      await _local.clearActiveBroadcastId(_currentUserId);
      state.value = const .ended();
      status.value = .offAir;
      log.i('LiveSessionManager: Ended live session with error: $message ');
    });

    // Listen for errors on the LiveKit toggle microphone
    toggleMicrophone.errors.listen((error, _) {
      final inner = error?.error;
      if (inner == null) return;
      log.e('LiveSessionManager: Failed to toggle microphone - $inner');
    });
  }

  void _handleLiveKitStateChange(LiveKitState state) {
    switch (state) {
      case .connected:
        status.value = .live;
        _reconnectionAttempts = 0;
        _reconnectionTimer?.cancel();

        // Resume timer if it was paused
        if (!timer.isRunning.value) timer.resume.run();
      case .connecting:
        status.value = .connecting;
      case .reconnecting:
        status.value = .reconnecting;

        // Pause timer during reconnection
        if (timer.isRunning.value) timer.pause.run();
      case .disconnected:
        status.value = .disconnected;

        // Pause timer on disconnection
        if (timer.isRunning.value) timer.pause.run();

        // Auto-reconnect if session is still active
        if (this.state.value is! LiveSessionError) _scheduleReconnection();
    }
  }

  void _handleHostDisconnected(dynamic data) {
    // Only relevant for listeners
    if (isHost.value) return;

    log.w('LiveSessionManager: Host disconnected from broadcast');
    status.value = .hostDisconnected;
    state.value = const .hostDisconnected();

    // Pause timer for listeners when host disconnects
    if (timer.isRunning.value) timer.pause.run();
  }

  void _handleHostReconnected(dynamic data) {
    // Only relevant for listeners
    if (isHost.value) return;

    log.i('LiveSessionManager: Host reconnected to broadcast');
    status.value = .live;

    // Restore previous state
    state.value = const .streaming();

    // Resume timer for listeners when host reconnects
    if (!timer.isRunning.value) timer.resume.run();
  }

  Future<void> _handleOnBroadcastEnded(EndedBroadcast data) async {
    log.i('LiveSessionManager: Broadcast ended by host');

    // Stop timer
    timer.stop.run();

    state.value = const .ended();
    status.value = .offAir;

    // Clean up session
    await _livekit.disconnect();
    await _local.clearActiveBroadcastId(_currentUserId);
  }

  void _scheduleReconnection() {
    if (_reconnectionAttempts >= _maxReconnectionAttempts) {
      // Throw error, reset status & stop timer after max reconnection attempts
      state.value = const .error('Connection lost. Please restart');
      status.value = .offAir;
      timer.stop.run();
      return;
    }

    _reconnectionAttempts++;
    final delay = Duration(seconds: _reconnectionAttempts * 2);
    log.f('Retrying reconnection $_reconnectionAttempts in ${delay.inSeconds}');

    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(delay, _connectToLiveKit.run);
  }

  String _getErrorMessage(Object? error) {
    if (error is MenoException) return error.message;
    return error.toString();
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('LiveSessionManager: Disposing');

    _reconnectionTimer?.cancel();

    await _liveKitStateSubscription?.cancel();
    await _endedBroadcastSubscription?.cancel();
    await _hostDisconnectedSubscription?.cancel();
    await _hostReconnectedSubscription?.cancel();

    _liveKitStateSubscription = null;
    _endedBroadcastSubscription = null;
    _hostDisconnectedSubscription = null;
    _hostReconnectedSubscription = null;

    await timer.onDispose();

    broadcast.dispose();
    state.dispose();
    status.dispose();
    isMicrophoneEnabled.dispose();
    isHost.dispose();
    hostProxy.dispose();

    setupConfigs.dispose();
    _initializeSession.dispose();
    _connectToLiveKit.dispose();
    _emitSocketEvent.dispose();
    _finalizeSession.dispose();
    endSession.dispose();
    toggleMicrophone.dispose();
    reconnectToSocket.dispose();
  }
}
