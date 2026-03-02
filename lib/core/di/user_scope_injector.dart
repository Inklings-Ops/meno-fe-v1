import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/shared/shared.dart';

class UserScopeInjector with MLogger implements Disposable, WillSignalReady {
  UserScopeInjector(this._repository);

  final IAuthRepository _repository;

  static const String _scopeName = 'user_scope';

  Id? _currentUserId;
  ListenableSubscription? _subscription;

  /// Initialize the handler and set up auth listener.
  ///
  /// Call this ONCE during app initialization, after core dependencies
  /// are registered but before the app widget tree is built.
  Future<void> initialize() async {
    _subscription = _repository.activeUserId.listen((userIdOption, _) {
      userIdOption.match(
        () {
          // No user - clear scope
          log.d('🔄 UserScope: No active user, clearing scope');
          clearUserScope();
        },
        (userId) async {
          // User changed - recreate scope
          if (_currentUserId != userId) {
            log.d('🔄 UserScope: Switching from $_currentUserId to $userId');
            await switchToUser(userId);
          }
        },
      );
    });

    // Initialize for current user if any
    _repository.activeUserId.value.fold(
      () => log.d('🔄 UserScope: No initial user'),
      switchToUser,
    );
  }

  /// Switch to a new user by recreating the entire user scope.
  ///
  /// This:
  /// 1. Disposes all existing user-scoped services
  /// 2. Removes the old scope
  /// 3. Creates a fresh scope for the new user
  /// 4. Registers all user-dependent dependencies
  Future<void> switchToUser(Id userId) async {
    try {
      log.d('🔄 UserScope: Starting switch to user ${userId.getOrCrash()}');

      // Dispose existing scope if any
      await _disposeCurrentScope();

      // Store new user ID
      _currentUserId = userId;

      // Create fresh scope
      di.pushNewScope(scopeName: _scopeName);
      log.d('✅ UserScope: Created new scope for ${userId.getOrCrash()}');

      // Register user-dependent dependencies
      await _registerDependencies(userId);
      log.d('✅ UserScope: All dependencies registered');

      // Signal the ready state
      GetIt.instance.signalReady(this);
      log.d('✅ UserScope: All dependencies ready');
    } catch (e, stack) {
      log.e('❌ UserScope: Error switching user: $e');
      log.w('Stack: $stack');
      rethrow;
    }
  }

  /// Clear the user scope (on logout).
  Future<void> clearUserScope() async {
    try {
      log.d('🔄 UserScope: Clearing scope');
      await _disposeCurrentScope();
      _currentUserId = null;
      log.d('✅ UserScope: Scope cleared');
    } catch (e, stack) {
      log.d('❌ UserScope: Error clearing scope: $e');
      log.d('Stack: $stack');
    }
  }

  /// Dispose the current scope if it exists.
  Future<void> _disposeCurrentScope() async {
    if (_currentUserId != null && di.currentScopeName == _scopeName) {
      try {
        await di.popScope();
        log.d('✅ UserScope: Previous scope disposed');
      } catch (e) {
        log.e('⚠️ UserScope: Error disposing scope: $e');
      }
    }
  }

  /// Register all user-dependent dependencies in the current scope.
  Future<void> _registerDependencies(Id userId) async {
    final credential = di<IAuthRepository>().accounts.value[userId];
    if (credential == null) {
      log.w('UserScope: No credentials found for $userId. Aborting.');
      return;
    }

    // ==================================================================
    // DOMAIN LAYER
    // ==================================================================
    di.registerSingleton<Id>(userId);
    di.registerSingleton<Session>(credential.session);

    // ==================================================================
    // INFRASTRUCTURE LAYER
    // ==================================================================
    di.registerSingletonAsync<WebSocketClient>(() async {
      final client = WebSocketClient(
        url: Env.webSocketUrl,
        token: credential.session.accessToken.getOrCrash(),
      );
      await client.connect();
      return client;
    });

    // Broadcast
    di.registerSingletonWithDependencies(
      () => BroadcastLocalDataSource(di<LocalStorage>()),
      dependsOn: [LocalStorage],
    );

    di.registerSingletonWithDependencies(
      () => BroadcastHttpDataSource(di<ApiClient>()),
      dependsOn: [ApiClient],
    );

    di.registerSingletonWithDependencies(
      () => BroadcastSocketDataSource(di<WebSocketClient>()),
      dependsOn: [WebSocketClient],
    );

    di.registerSingletonAsync<IBroadcastRepository>(
      () async => BroadcastRepositoryImpl(
        local: di<BroadcastLocalDataSource>(),
        http: di<BroadcastHttpDataSource>(),
        socket: di<BroadcastSocketDataSource>(),
      ),
      dependsOn: [
        BroadcastLocalDataSource,
        BroadcastHttpDataSource,
        BroadcastSocketDataSource,
      ],
    );

    di.registerSingletonWithDependencies<IBroadcastFeedSource>(
      () => di<IBroadcastRepository>() as IBroadcastFeedSource,
      dependsOn: [IBroadcastRepository],
    );

    // Notes/Folders
    di.registerSingletonWithDependencies(
      () => NotesLocalDataSource(di<Database>()),
      dependsOn: [Database],
    );

    di.registerSingletonWithDependencies(
      () => NotesRemoteDataSource(di<ApiClient>()),
      dependsOn: [ApiClient],
    );

    di.registerSingletonAsync<INotesRepository>(() async {
      return NotesRepositoryImpl(
        local: di<NotesLocalDataSource>(),
        remote: di<NotesRemoteDataSource>(),
      );
    }, dependsOn: [NotesLocalDataSource, NotesRemoteDataSource]);

    // Discover
    di.registerSingletonWithDependencies(
      () => DiscoverLocalDataSource(di<LocalStorage>()),
      dependsOn: [LocalStorage],
    );

    // Profile
    di.registerSingletonWithDependencies(
      () => ProfileHttpDataSource(di<ApiClient>()),
      dependsOn: [ApiClient],
    );

    di.registerSingletonWithDependencies(
      () => ProfileLocalDataSource(di<LocalStorage>()),
      dependsOn: [LocalStorage],
    );

    di.registerSingletonAsync<IProfileRepository>(() async {
      final repository = ProfileRepositoryImpl(
        http: di<ProfileHttpDataSource>(),
        local: di<ProfileLocalDataSource>(),
        currentUserId: userId,
      );
      await repository.initialize();
      return repository;
    }, dependsOn: [ProfileHttpDataSource, ProfileLocalDataSource]);

    // ==================================================================
    // APPLICATION LAYER
    // ==================================================================
    // Live Broadcast/Stream Session
    di.registerSingletonAsync(() async {
      final scope = LiveScopeInjector(
        repository: di<IBroadcastRepository>(),
        userId: userId,
      );
      await scope.initialize();
      return scope;
    }, dependsOn: [IBroadcastRepository]);

    // Broadcasts
    di.registerSingletonWithDependencies(() {
      return BroadcastFormManager(
        userId: userId,
        repository: di<IBroadcastRepository>(),
        mediaService: di<MediaService>(),
      );
    }, dependsOn: [IBroadcastRepository, MediaService]);

    di.registerSingletonWithDependencies(() {
      final manager = RecentlyLiveBroadcastsManager(di<IBroadcastRepository>());
      manager.initialize.run();
      return manager;
    }, dependsOn: [IBroadcastRepository]);

    di.registerSingletonWithDependencies(() {
      final manager = NowLiveBroadcastsManager(di<IBroadcastRepository>());
      manager.initialize.run();
      return manager;
    }, dependsOn: [IBroadcastRepository]);

    // Notes/Folders
    di.registerSingletonWithDependencies(() {
      final manager = NotesManager(di<INotesRepository>());
      manager.initialize.run();
      return manager;
    }, dependsOn: [INotesRepository]);

    di.registerSingletonWithDependencies(() {
      final manager = FoldersManager(di<INotesRepository>());
      manager.initialize.run();
      return manager;
    }, dependsOn: [INotesRepository]);

    di.registerSingletonWithDependencies(() {
      return NoteActionsManager(di<INotesRepository>());
    }, dependsOn: [INotesRepository]);

    // Discover
    di.registerSingleton<DiscoverManager>(DiscoverManager());

    di.registerSingletonWithDependencies(() {
      final manager = DiscoverNowLiveManager(di<IBroadcastFeedSource>());
      manager.initialize.run();
      return manager;
    }, dependsOn: [IBroadcastFeedSource]);

    di.registerSingletonWithDependencies(() {
      final manager = DiscoverRecentlyLiveManager(di<IBroadcastFeedSource>());
      manager.initialize.run();
      return manager;
    }, dependsOn: [IBroadcastFeedSource]);

    // Profile
    di.registerSingletonWithDependencies<MyProfileManager>(
      () => MyProfileManager(di<IProfileRepository>()),
      dependsOn: [IProfileRepository],
    );

    di.registerSingletonWithDependencies<MyRecentBroadcastsManager>(() {
      final manager = MyRecentBroadcastsManager(
        currentUserId: userId,
        broadcastFeedSource: di<IBroadcastFeedSource>(),
      );
      manager.initialize.run();
      return manager;
    }, dependsOn: [IBroadcastFeedSource]);

    di.registerSingletonWithDependencies<MyBroadcastsManager>(() {
      final manager = MyBroadcastsManager(
        currentUserId: userId,
        broadcastFeedSource: di<IBroadcastFeedSource>(),
      );
      manager.initialize.run();
      return manager;
    }, dependsOn: [IBroadcastFeedSource]);
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('🧹 UserScope: Disposing scope resources');
    _subscription?.cancel();
  }
}
