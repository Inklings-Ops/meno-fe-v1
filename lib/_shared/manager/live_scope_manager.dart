import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/chat/chat.dart';

class LiveScopeManager with MLogger implements Disposable {
  LiveScopeManager({
    required BroadcastHttpService http,
    required BroadcastLocalService local,
    required BroadcastSocketService socket,
    required Id currentUserId,
  }) : _http = http,
       _local = local,
       _socket = socket,
       _currentUserId = currentUserId;

  final BroadcastHttpService _http;
  final BroadcastLocalService _local;
  final BroadcastSocketService _socket;
  final Id _currentUserId;

  StreamSubscription<BroadcastSession?>? _sessionSub;
  StreamSubscription<EndedBroadcast>? _endedBroadcastSub;
  StreamSubscription? _socketReconnectionSub;

  Future<void> _queue = Future<void>.value();
  String? _currentScopeName;

  Future<void> initialize() async {
    log.i('LiveScopeManager: Initializing for user $_currentUserId');

    // Check for zombie broadcast state on startup
    await _checkForZombieBroadcast();

    _sessionSub = _local.watchActiveSession(_currentUserId).listen((session) {
      log.d('LiveScopeManager: Session changed - ${session?.broadcast.id}');

      // Queue the scope operation to prevent race conditions
      _queue = _queue.then((_) async {
        if (session == null) return _popScope();
        return _pushScope(session);
      });
    }, onError: (dynamic e) => log.e('LivenScopManager: Session error - $e'));
    _socketReconnectionSub = _socket.onReconnected.listen((_) async {
      log.i('LiveScopeManager: Socket reconnected');

      // Get current session
      final session = _local.getActiveBroadcastSession(_currentUserId);
      if (session?.isExpired ?? false) return;

      // Only attempt if the live scope is actually active
      if (!di.isRegistered<LiveSessionManager>()) return;

      log.i('LiveScopeManager: Socket reconnected');

      try {
        final manager = di<LiveSessionManager>();
        await manager.reconnectToSocket.runAsync();

        // Redirect once reconnect is successful
        final router = di<MenoRouter>().config;
        final location =
            router.routerDelegate.currentConfiguration.last.matchedLocation;

        if (!location.startsWith('/live')) {
          router.go(R.liveSessionInitialization);
        }
      } catch (e) {
        log.e('LiveScopeManager: Reconnect redirect error - $e');
      }
    }, onError: (dynamic e) => log.e('LiveScopeManager: Recon. error - $e'));
    _endedBroadcastSub = _socket.onEndedBroadcast.listen((data) async {
      await _popScope();
    });
  }

  // #########################################################################
  // PRIVATE METHODS
  // #########################################################################

  /// Pushes the new live scope
  Future<void> _pushScope(BroadcastSession session) async {
    final broadcastId = session.broadcast.id;
    final targetScopeName = 'live_${broadcastId.getOrCrash()}';

    // Check if already in this scope
    if (_currentScopeName == targetScopeName) {
      log.i('LiveScopeManager: Already in $targetScopeName');
      return;
    }

    // Exit current live scope if exists
    if (_currentScopeName != null) await _popScope();

    try {
      await di.pushNewScopeAsync(
        scopeName: targetScopeName,
        init: (getIt) async {
          // Broadcast Session
          getIt.registerSingletonAsync<BroadcastSession>(() async => session);

          // LiveKit SDK Client
          getIt.registerSingletonAsync(() async {
            return LiveKitClient.initialize(Env.menoLiveKitUrl);
          });

          // Live Session Manager
          getIt.registerSingletonAsync(
            () async => LiveSessionManager(
              session: session,
              local: getIt<BroadcastLocalService>(),
              socket: getIt<BroadcastSocketService>(),
              livekit: getIt<LiveKitClient>(),
            ),
            dependsOn: [
              BroadcastLocalService,
              BroadcastSocketService,
              LiveKitClient,
            ],
            onCreated: (manager) => manager.setupConfigs.run(),
            signalsReady: true,
          );

          // Participants
          getIt.registerSingletonWithDependencies(
            () {
              final manager = ParticipantsManager(
                http: getIt<BroadcastHttpService>(),
                socket: getIt<BroadcastSocketService>(),
                session: session,
              );
              manager.initialize.run();
              return manager;
            },
            dependsOn: [
              BroadcastHttpService,
              BroadcastSocketService,
              LiveSessionManager,
            ],
          );

          // Chats
          getIt.registerSingletonWithDependencies(() {
            return ChatHttpService(getIt<HttpClient>());
          }, dependsOn: [HttpClient]);
          getIt.registerSingletonWithDependencies(() {
            return ChatSocketService(getIt<SocketClient>());
          }, dependsOn: [SocketClient]);
          getIt.registerSingletonWithDependencies(
            () {
              final manager = ChatListManager(
                http: getIt<ChatHttpService>(),
                socket: getIt<ChatSocketService>(),
                session: session,
              );
              manager.initialize.run();
              return manager;
            },
            dependsOn: [ChatHttpService, ChatSocketService, LiveSessionManager],
          );
          getIt.registerSingletonWithDependencies(() {
            return ChatManager(
              socket: getIt<ChatSocketService>(),
              session: session,
            );
          }, dependsOn: [ChatSocketService, LiveSessionManager]);
        },
      );
      _currentScopeName = targetScopeName;
      log.i('LiveScopeManager: Entered $targetScopeName successfully');
    } catch (error, stackStrace) {
      log.e('LiveScopeManager Error', error: error, stackTrace: stackStrace);
      await _local.clearActiveBroadcastId(_currentUserId);
      rethrow;
    }
  }

  /// Ends the session and pops the live scope
  Future<void> _popScope() async {
    if (_currentScopeName == null) {
      log.d('LiveScopeManager: No live scope to exit');
      return;
    }

    try {
      log.i('LiveScopeManager: Exiting $_currentScopeName');

      final isLiveRegistered = di.isRegistered<LiveSessionManager>();
      final isParticipantsRegistered = di.isRegistered<ParticipantsManager>();

      // Save summary before destroying scope
      if (isLiveRegistered && isParticipantsRegistered) {
        final liveManager = di<LiveSessionManager>();
        final participantsManager = di<ParticipantsManager>();

        final summary = BroadcastSummary(
          broadcast: liveManager.broadcast.value,
          duration: liveManager.timer.currentElapsed,
          formattedDuration: liveManager.timer.formattedTime.value,
          qualityScore: liveManager.timer.qualityScore,
          totalParticipants: participantsManager.totalCount.value,
          allTimeParticipants: participantsManager.allTimeCount.value,
          recentParticipants: participantsManager.recentParticipants.value,
        );

        await _local.saveBroadcastSummary(_currentUserId, summary);
      }

      // GetIt will automatically dispose all registered services
      await di.popScope();
      _currentScopeName = null;
      log.i('LiveScopeManager: Exited live scope successfully');
    } catch (e) {
      log.e('LiveScopeManager: Error exiting live scope - $e');
      _currentScopeName = null;
    }
  }

  /// Check for zombie broadcast on app startup
  Future<void> _checkForZombieBroadcast() async {
    final session = _local.getActiveBroadcastSession(_currentUserId);
    if (session == null) return;

    if (session.isExpired) {
      log.w('LiveScopeManager: Session is expired. Clearing...');
      await _local.clearActiveBroadcastId(_currentUserId);
      return;
    }

    try {
      final broadcast = await _http.getBroadcast(session.broadcast.id);
      if (broadcast.isActive) {
        log.i('LiveScopeManager: Broadcast active, recovering session');
        await _pushScope(session);

        // Redirect to live session on recovery
        di<MenoRouter>().config.go(R.liveSessionInitialization);
      } else {
        log.w('LiveScopeManager: Broadcast is no longer active, clearing');
        await _local.clearActiveBroadcastId(_currentUserId);
      }
    } catch (error) {
      log.e('LiveScopeManager: Zombie broadcast is invalid, clearing');
      await _local.clearActiveBroadcastId(_currentUserId);
    }

    log.w('LiveScopeManager: Found zombie broadcast - ${session.broadcast.id}');
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('LiveScopeManager: Disposing');

    await _sessionSub?.cancel();
    await _socketReconnectionSub?.cancel();
    await _endedBroadcastSub?.cancel();

    _sessionSub = null;
    _socketReconnectionSub = null;
    _endedBroadcastSub = null;

    await _popScope();

    log.d('LiveScopeManager: Disposed');
  }
}
