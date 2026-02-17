import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

final class UserScopeHandler with MLogger implements Disposable {
  UserScopeHandler(this._repository) {
    // LISTEN: We watch the Anchor
    _subscription = _repository.activeUserId.listen(_syncScopeWithState);

    // Initial check (fire and forget, but processed in order)
    _syncScopeWithState(_repository.activeUserId.value, _subscription);
  }

  final IAuthRepository _repository;
  late final ListenableSubscription _subscription;

  Future<void> _queue = Future<void>.value();

  void _syncScopeWithState(Option<Id> id, ListenableSubscription _) {
    // This forces _enterScope to wait until _exitScope (if running)
    // is 100% done.
    _queue = _queue.then((_) async => id.fold(_exitScope, _enterScope));
  }

  Future<void> _enterScope(Id userId) async {
    final targetScopeName = 'user_${userId.value.getOrElse((_) => '')}';
    log.i('ScopeHandler: Requesting enter $targetScopeName');

    // Safety Check: Don't push if we are already in this user's scope
    // Now that we wait for exitScope, this check is safe and accurate.
    if (di.currentScopeName == targetScopeName) {
      log.i('ScopeHandler: Already in $targetScopeName. Skipping.');
      return;
    }

    // Clean up old scope if switching users
    await _exitScope();

    // Get Data from Vault (Repo)
    // The Orchestrator is allowed to talk to the Repo to get the data needed
    // for injection
    final credentials = _repository.accounts.value[userId];

    if (credentials != null) {
      di.pushNewScope(
        isFinal: true,
        scopeName: targetScopeName,
        init: (_) async {
          // ==================================================================
          // DOMAIN LAYER
          // ==================================================================
          di.registerSingleton<Session>(credentials.session);

          // ==================================================================
          // INFRASTRUCTURE LAYER
          // ==================================================================
          di.registerSingletonAsync<WebSocketClient>(() async {
            final client = WebSocketClient(
              url: Env.webSocketUrl,
              token: credentials.session.accessToken.getOrCrash(),
            );
            await client.connect();
            return client;
          });

          di.registerSingletonWithDependencies(
            () => BroadcastLocalDataSource(di<LocalStorage>()),
            dependsOn: [LocalStorage],
          );

          di.registerSingletonWithDependencies(
            () => BroadcastRemoteDataSource(
              api: di<ApiClient>(),
              socket: di<WebSocketClient>(),
            ),
            dependsOn: [ApiClient, WebSocketClient],
          );

          di.registerSingletonAsync<IBroadcastRepository>(() async {
            return BroadcastRepositoryImpl(
              local: di<BroadcastLocalDataSource>(),
              remote: di<BroadcastRemoteDataSource>(),
            );
          }, dependsOn: [BroadcastLocalDataSource, BroadcastRemoteDataSource]);

          // ==================================================================
          // APPLICATION LAYER
          // ==================================================================
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
            final manager = NowLiveBroadcastsManager(
              di<IBroadcastRepository>(),
            );
            manager.initialize.run();
            return manager;
          }, dependsOn: [IBroadcastRepository]);

          di.registerSingletonWithDependencies(() async {
            final handler = LiveScopeHandler(
              repository: di<IBroadcastRepository>(),
              userId: userId,
            );
            await handler.initialize();
            return handler;
          }, dependsOn: [IBroadcastRepository]);
        },
      );
    }
  }

  Future<void> _exitScope() async {
    // Only pop if we are NOT at the root
    if (di.currentScopeName != 'root') {
      log.d('ScopeHandler: Popping scope ${di.currentScopeName}');
      await di.popScope();
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    _subscription.cancel();
  }
}
