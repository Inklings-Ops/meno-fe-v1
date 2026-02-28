import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/features/discover/applications/applications.dart';
import 'package:meno/features/discover/infrastructure/infrastructure.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/infrastructure/infrastructure.dart';
import 'package:meno/features/profile/applications/my_profile_manager.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/features/profile/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno/shared/shared.dart' show IBroadcastFeedSource;

final class UserScopeHandler with MLogger implements Disposable {
  UserScopeHandler(this._repository) {
    // LISTEN: We watch the Anchor
    _subscription = _repository.activeUserId.listen(_syncScopeWithState);

    // Initial check (fire and forget, but processed in order)
    _syncScopeWithState(_repository.activeUserId.value, _subscription);
  }

  final isScopeReady = ValueNotifier(false);

  final IAuthRepository _repository;
  late final ListenableSubscription _subscription;

  Future<void> _queue = Future<void>.value();

  void _syncScopeWithState(Option<Id> id, ListenableSubscription _) {
    // This forces _enterScope to wait until exitScope (if running)
    // is 100% done.
    _queue = _queue.then((_) async => id.fold(exitScope, enterScope));
  }

  int _scopeNumber = 1;

  Future<void> enterScope(Id userId) async {
    _scopeNumber++;
    final targetScopeName = '${_scopeNumber}_${userId.getOrCrash()}';
    log.i('ScopeHandler: Requesting enter $targetScopeName');

    // Guard: already in this exact scope, nothing to do
    if (di.currentScopeName == targetScopeName) {
      log.i('ScopeHandler: Already in $targetScopeName. Skipping.');
      return;
    }

    // Exit any existing user scope BEFORE pushing the new one
    await exitScope();

    final credential = _repository.accounts.value[userId];
    if (credential == null) {
      log.w('ScopeHandler: No credentials found for $userId. Aborting.');
      return;
    }

    log.i('ScopeHandler: Entering $targetScopeName');

    await di.pushNewScopeAsync(
      scopeName: targetScopeName,
      init: (_) async {
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
          () async {
            return BroadcastRepositoryImpl(
              local: di<BroadcastLocalDataSource>(),
              http: di<BroadcastHttpDataSource>(),
              socket: di<BroadcastSocketDataSource>(),
            );
          },
          dependsOn: [
            BroadcastLocalDataSource,
            BroadcastHttpDataSource,
            BroadcastSocketDataSource,
          ],
        );

        // Narrow feed interface alias — same instance, no extra cost
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

        // Broadcasts
        di.registerSingletonWithDependencies(() {
          return BroadcastFormManager(
            userId: userId,
            repository: di<IBroadcastRepository>(),
            mediaService: di<MediaService>(),
          );
        }, dependsOn: [IBroadcastRepository, MediaService]);

        di.registerSingletonWithDependencies(() {
          final manager = RecentlyLiveBroadcastsManager(
            di<IBroadcastRepository>(),
          );
          manager.initialize.run();
          return manager;
        }, dependsOn: [IBroadcastRepository]);

        di.registerSingletonWithDependencies(() {
          final manager = NowLiveBroadcastsManager(di<IBroadcastRepository>());
          manager.initialize.run();
          return manager;
        }, dependsOn: [IBroadcastRepository]);

        // Live Broadcast/Stream Session
        di.registerSingletonWithDependencies(() async {
          final handler = LiveScopeHandler(
            repository: di<IBroadcastRepository>(),
            userId: userId,
          );
          await handler.initialize();
          return handler;
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
          final mgr = DiscoverRecentlyLiveManager(di<IBroadcastFeedSource>());
          mgr.initialize.run();
          return mgr;
        }, dependsOn: [IBroadcastFeedSource]);

        // Profile
        di.registerSingletonWithDependencies<MyProfileManager>(
          () => MyProfileManager(di<IProfileRepository>()),
          dependsOn: [IProfileRepository],
        );

        await di.allReady();
      },
    );

    isScopeReady.value = true;
    log.i('ScopeHandler: Scope $targetScopeName is ready');
  }

  Future<void> exitScope() async {
    if (di.currentScopeName == 'root') return;

    // Signal to UI immediately: don't render user-scoped widgets anymore
    isScopeReady.value = false;

    log.d('ScopeHandler: Popping scope ${di.currentScopeName}');
    await di.popScope();
  }

  @override
  FutureOr<dynamic> onDispose() {
    _subscription.cancel();
    isScopeReady.dispose();
  }
}
