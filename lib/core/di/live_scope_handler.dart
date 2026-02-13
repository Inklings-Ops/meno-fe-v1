import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// Orchestrates the LiveKit session scope lifecycle
///
/// This handler:
/// - Watches for active broadcast sessions
/// - Creates/destroys LiveKit session scope
/// - Manages crash recovery (zombie broadcast state)
/// - Coordinates socket events with LiveKit connection
///
/// Register this ONCE in the user scope (not in root injector)
final class LiveScopeHandler with MenoLogger implements Disposable {
  LiveScopeHandler({
    required Id userId,
    required IBroadcastRepository repository,
  }) : _userId = userId,
       _repository = repository;

  final Id _userId;
  final IBroadcastRepository _repository;

  StreamSubscription<BroadcastSession?>? _sessionSub;
  StreamSubscription<Unit>? _socketReconnectionSub;

  Future<void> _queue = Future<void>.value();
  String? _currentScopeName;

  Future<void> initialize() async {
    log.i('LiveScopeHandler: Initializing for user $_userId');

    // Check for zombie broadcast state on startup
    await _checkForZombieBroadcast();

    // Watch for active session changes
    _sessionSub = _repository.watchActiveSession(_userId).listen((session) {
      log.d('LiveScopeHandler: Session changed - ${session?.broadcast.id}');

      // Queue the scope operation to prevent race conditions
      _queue = _queue.then((_) async {
        if (session != null) {
          await _enterLiveScope(session);
        } else {
          await _exitLiveScope();
        }
      });
    }, onError: (dynamic e) => log.e('LivenScopeHandler: Session error - $e'));

    _socketReconnectionSub = _repository.onReconnected.listen((_) {
      log.i('LiveScopeHandler: Socket reconnected');

      // Get current session
      final session = _repository.getActiveBroadcastSession(_userId);
      if (session.isNone()) return;

      // Notify LiveSessionManager about socket reconnection
      try {
        log.i('LiveScopeHandler: Socket reconnected');
        // TODO(gettoknowdavid): Handle the reconnection logic
        final manager = di<LiveSessionManager>();
        manager.reconnectToSocket.run();
      } catch (e) {
        log.e('LiveScopeHandler: Failed to handle socket reconnection - $e');
      }
    }, onError: (dynamic e) => log.e('LivenScopeHandler: Recon. error - $e'));
  }

  /// Check for zombie broadcast on app startup
  Future<void> _checkForZombieBroadcast() async {
    final session = _repository.getActiveBroadcastSession(_userId);
    return session.fold(() => null, (data) async {
      log.w('LiveScopeHandler: Found zombie broadcast - ${data.broadcast.id}');

      if (data.isExpired) {
        log.w('LiveScopeHandler: Session is expired. Clearing...');
        await _repository.clearActiveBroadcast(_userId);
        return;
      }

      final broadcastOr = await _repository.getBroadcast(data.broadcast.id);

      return broadcastOr.fold(
        (failure) async {
          log.e('LiveScopeHandler: Zombie broadcast is invalid, clearing');
          await _repository.clearActiveBroadcast(_userId);
        },
        (broadcast) async {
          if (broadcast.isActive) {
            log.i('LiveScopeHandler: Broadcast active, recovering session');
          } else {
            log.w('LiveScopeHandler: Broadcast is no longer active, clearing');
            await _repository.clearActiveBroadcast(_userId);
          }
        },
      );
    });
  }

  Future<void> _enterLiveScope(BroadcastSession session) async {
    final targetScopeName = 'live_${session.broadcast.id.getOrCrash()}';

    // Check if already in this scope
    if (_currentScopeName == targetScopeName) {
      log.i('LiveScopeHandler: Already in $targetScopeName');
      return;
    }

    // Exit current live scope if exists
    if (_currentScopeName != null) await _exitLiveScope();

    log.i('LiveScopeHandler: Entering $targetScopeName');

    try {
      await di.pushNewScopeAsync(
        scopeName: targetScopeName,
        init: (_) async {
          // ================================================================
          // INFRASTRUCTURE LAYER
          // ================================================================

          // LiveKit Client - Register as async singleton
          di.registerSingletonAsync<LiveKitClient>(() async {
            log.d('LiveScopeHandler: Initializing LiveKit client');
            final client = LiveKitClient(url: Env.menoLiveKitUrl);
            client.initialize();
            log.d('LiveScopeHandler: LiveKit client initialized');
            return client;
          });

          // Wait for LiveKit to be ready
          await di.isReady<LiveKitClient>();
          log.d('LiveScopeHandler: LiveKit client is ready');

          // ================================================================
          // APPLICATION LAYER
          // ================================================================

          // Live Session Manager - Register synchronously to avoid deadlock

          // Register as regular singleton (not async)
          di.registerSingletonAsync<LiveSessionManager>(() async {
            log.d('LiveScopeHandler: Initializing Live Session Manager');
            final manager = LiveSessionManager(
              userId: _userId,
              session: session,
              repository: di<IBroadcastRepository>(),
              liveKit: di<LiveKitClient>(),
            );
            log.d('LiveScopeHandler: Starting session...');
            await manager.initializeTimer.runAsync();
            log.d('LiveScopeHandler: Session started successfully');
            return manager;
          }, dependsOn: [LiveKitClient, IBroadcastRepository]);

          // Wait for timer initialization (piped command)
          // Give it a moment to complete
          await Future<void>.delayed(const Duration(milliseconds: 100));
        },
      );
      _currentScopeName = targetScopeName;
      log.i('LiveScopeHandler: Entered $targetScopeName successfully');
      log.i('LiveScopeHandler: Live scope is now ready for UI');
    } catch (e, stackTrace) {
      log.e('LiveScopeHandler: Failed to enter scope - $e');
      log.e('Stack trace: $stackTrace');
      // Clean up session on failure
      await _repository.clearActiveBroadcast(_userId);
      rethrow; // Re-throw so error is visible
    }
  }

  Future<void> _exitLiveScope() async {
    if (_currentScopeName == null) {
      log.d('LiveScopeHandler: No live scope to exit');
      return;
    }

    log.i('LiveScopeHandler: Exiting $_currentScopeName');

    try {
      // GetIt will automatically dispose all registered services
      await di.popScope();
      _currentScopeName = null;
      log.i('LiveScopeHandler: Exited live scope successfully');
    } catch (e) {
      log.e('LiveScopeHandler: Error exiting live scope - $e');
      _currentScopeName = null;
    }
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('LiveScopeHandler: Disposing');

    await _sessionSub?.cancel();
    await _socketReconnectionSub?.cancel();

    // Exit live scope if active
    await _exitLiveScope();

    log.d('LiveScopeHandler: Disposed');
  }
}
