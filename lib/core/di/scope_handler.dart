import 'dart:async';
import 'dart:developer';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

final class ScopeHandler implements Disposable {
  ScopeHandler(this._repository) {
    // LISTEN: We watch the Anchor
    _subscription = _repository.activeUserId.listen(_syncScopeWithState);
    _repository.activeUserId.value.fold(() {}, _enterScope);
  }

  final IAuthRepository _repository;

  late final ListenableSubscription _subscription;

  void _syncScopeWithState(Option<Id> id, ListenableSubscription _) {
    id.fold(_exitScope, _enterScope);
  }

  Future<void> _enterScope(Id userId) async {
    log('''
  ###########################################################################
  # AUTHENTICATED SCOPE : ${userId.value.getOrElse((_) => '')}              #
  ###########################################################################
  ''');
    // Safety Check: Don't push if we are already in this user's scope
    if (di.currentScopeName == 'user_${userId.value}') return;

    // Clean up old scope if switching users
    await _exitScope();

    // Get Data from Vault (Repo)
    // The Orchestrator is allowed to talk to the Repo to get the data needed
    // for injection
    final credentials = _repository.accounts.value[userId];

    if (credentials != null) {
      di.pushNewScope(
        isFinal: true,
        scopeName: 'user_${userId.value}',
        init: (_) async {
          // ==================================================================
          // DOMAIN LAYER
          // ==================================================================
          di.registerSingleton<Session>(credentials.session);

          // ==================================================================
          // INFRASTRUCTURE LAYER
          // ==================================================================
          di.registerSingletonWithDependencies(
            () => BroadcastLocalDataSource(di<LocalStorage>()),
            dependsOn: [LocalStorage],
          );

          di.registerSingletonWithDependencies(
            () => BroadcastRemoteDataSource(di<ApiClient>()),
            dependsOn: [ApiClient],
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
              currentUserId: userId,
              repository: di<IBroadcastRepository>(),
            );
          }, dependsOn: [IBroadcastRepository]);

          di.registerSingletonWithDependencies(() {
            final manager = RecentlyLiveBroadcastsManager(
              di<IBroadcastRepository>(),
            );
            manager.getBroadcasts.run();
            return manager;
          }, dependsOn: [IBroadcastRepository]);

          di.registerSingletonWithDependencies(() {
            final manager = NowLiveBroadcastsManager(
              di<IBroadcastRepository>(),
            );
            manager.getBroadcasts.run();
            return manager;
          }, dependsOn: [IBroadcastRepository]);
        },
      );
    }
  }

  Future<void> _exitScope() async {
    // Only pop if we are NOT at the root
    if (di.currentScopeName != 'root') {
      await di.popScope();
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    _subscription.cancel();
  }
}
