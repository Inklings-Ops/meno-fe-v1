import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';
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
class LiveScopeInjector with MLogger implements Disposable {
  LiveScopeInjector({
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
    log.i('LiveScopeInjector: Initializing for user $_userId');

    // Check for zombie broadcast state on startup
    await _checkForZombieBroadcast();

    // Watch for active session changes
    _sessionSub = _repository.watchActiveSession(_userId).listen((session) {
      log.d('LiveScopeInjector: Session changed - ${session?.broadcast.id}');

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
      log.i('LiveScopeInjector: Socket reconnected');

      // Get current session
      final session = _repository.getActiveBroadcastSession(_userId);
      if (session.isNone()) return;

      // Notify LiveSessionManager about socket reconnection
      try {
        log.i('LiveScopeInjector: Socket reconnected');
        // TODO(gettoknowdavid): Handle the reconnection logic
        final manager = di<LiveSessionManager>();
        manager.reconnectToSocket.run();
      } catch (e) {
        log.e('LiveScopeInjector: Failed to handle socket reconnection - $e');
      }
    }, onError: (dynamic e) => log.e('LivenScopeHandler: Recon. error - $e'));
  }

  /// Check for zombie broadcast on app startup
  Future<void> _checkForZombieBroadcast() async {
    final session = _repository.getActiveBroadcastSession(_userId);
    return session.fold(() => null, (data) async {
      log.w('LiveScopeInjector: Found zombie broadcast - ${data.broadcast.id}');

      if (data.isExpired) {
        log.w('LiveScopeInjector: Session is expired. Clearing...');
        await _repository.clearActiveBroadcast(_userId);
        return;
      }

      final broadcastOr = await _repository.getBroadcast(data.broadcast.id);

      return broadcastOr.fold(
        (failure) async {
          log.e('LiveScopeInjector: Zombie broadcast is invalid, clearing');
          await _repository.clearActiveBroadcast(_userId);
        },
        (broadcast) async {
          if (broadcast.isActive) {
            log.i('LiveScopeInjector: Broadcast active, recovering session');
          } else {
            log.w('LiveScopeInjector: Broadcast is no longer active, clearing');
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
      log.i('LiveScopeInjector: Already in $targetScopeName');
      return;
    }

    // Exit current live scope if exists
    if (_currentScopeName != null) await _exitLiveScope();

    log.i('LiveScopeInjector: Entering $targetScopeName');

    try {
      await di.pushNewScopeAsync(
        scopeName: targetScopeName,
        init: (_) async {
          // ================================================================
          // INFRASTRUCTURE LAYER
          // ================================================================
          di.registerSingletonAsync<BroadcastSession>(() async => session);

          di.registerSingletonAsync<ChatRemoteDataSource>(
            () async => ChatRemoteDataSource(
              api: di<ApiClient>(),
              socket: di<WebSocketClient>(),
            ),
            dependsOn: [ApiClient, WebSocketClient],
          );

          di.registerSingletonWithDependencies<IChatRepository>(
            () => ChatRepositoryImpl(remote: di<ChatRemoteDataSource>()),
            dependsOn: [ChatRemoteDataSource],
          );

          // LiveKit Client - Register as async singleton
          di.registerSingletonAsync<LiveKitClient>(() async {
            log.d('LiveScopeInjector: Initializing LiveKit client');
            final client = LiveKitClient(url: Env.menoLiveKitUrl);
            client.initialize();
            log.d('LiveScopeInjector: LiveKit client initialized');
            return client;
          });

          // Wait for LiveKit to be ready
          await di.isReady<LiveKitClient>();
          log.d('LiveScopeInjector: LiveKit client is ready');

          // ================================================================
          // APPLICATION LAYER
          // ================================================================

          // Live Session Manager - Register synchronously to avoid deadlock
          // Register as regular singleton (not async)
          di.registerSingletonAsync<LiveSessionManager>(
            () async => LiveSessionManager(
              userId: _userId,
              session: session,
              repository: di<IBroadcastRepository>(),
              liveKit: di<LiveKitClient>(),
            ),
            dependsOn: [LiveKitClient, IBroadcastRepository],
            onCreated: (manager) => manager.initializeTimer.run(),
            signalsReady: true,
          );

          di.registerSingletonWithDependencies(
            () {
              final manager = ParticipantsManager(
                repository: di<IBroadcastRepository>(),
                session: di<BroadcastSession>(),
              );
              manager.initialize.run();
              return manager;
            },
            dependsOn: [
              IBroadcastRepository,
              BroadcastSession,
              LiveSessionManager,
            ],
          );

          di.registerSingletonWithDependencies(
            () {
              final manager = ChatListManager(
                repository: di<IChatRepository>(),
                session: di<BroadcastSession>(),
              );
              manager.initialize.run();
              return manager;
            },
            dependsOn: [IChatRepository, BroadcastSession, LiveSessionManager],
          );

          di.registerSingletonWithDependencies(
            () => ChatManager(
              repository: di<IChatRepository>(),
              broadcastId: di<BroadcastSession>().broadcast.id,
              currentUserId: _userId,
            ),
            dependsOn: [IChatRepository, LiveSessionManager],
          );

          await di.allReady();
        },
      );
      _currentScopeName = targetScopeName;
      log.i('LiveScopeInjector: Entered $targetScopeName successfully');
      log.i('LiveScopeInjector: Live scope is now ready for UI');
    } catch (e, stackTrace) {
      log.e('LiveScopeInjector: Failed to enter scope - $e');
      log.e('Stack trace: $stackTrace');
      // Clean up session on failure
      await _repository.clearActiveBroadcast(_userId);
      rethrow; // Re-throw so error is visible
    }
  }

  Future<void> _exitLiveScope() async {
    if (_currentScopeName == null) {
      log.d('LiveScopeInjector: No live scope to exit');
      return;
    }

    log.i('LiveScopeInjector: Exiting $_currentScopeName');

    try {
      final isLiveRegistered = di.isRegistered<LiveSessionManager>();
      final isParticipantsRegistered = di.isRegistered<ParticipantsManager>();

      // Save summary before destroying scope
      if (isLiveRegistered && isParticipantsRegistered) {
        final summary = _captureSummary(
          di<LiveSessionManager>(),
          di<ParticipantsManager>(),
        );
        await _repository.saveBroadcastSummary(_userId, summary);
      }

      // GetIt will automatically dispose all registered services
      await di.popScope();
      _currentScopeName = null;
      log.i('LiveScopeInjector: Exited live scope successfully');
    } catch (e) {
      log.e('LiveScopeInjector: Error exiting live scope - $e');
      _currentScopeName = null;
    }
  }

  BroadcastSummary _captureSummary(
    LiveSessionManager liveManager,
    ParticipantsManager participantsManager,
  ) {
    return BroadcastSummary(
      broadcast: liveManager.broadcast,
      duration: liveManager.timer.currentElapsed,
      formattedDuration: liveManager.timer.formattedTime.value,
      qualityScore: liveManager.timer.qualityScore,
      totalParticipants: participantsManager.totalCount.value,
      allTimeParticipants: participantsManager.allTimeCount.value,
      recentParticipants: participantsManager.recentParticipants.value,
    );
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('LiveScopeInjector: Disposing');

    await _sessionSub?.cancel();
    await _socketReconnectionSub?.cancel();

    // Exit live scope if active
    await _exitLiveScope();

    log.d('LiveScopeInjector: Disposed');
  }
}
