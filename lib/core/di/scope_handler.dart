import 'dart:async';

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
  }

  final IAuthRepository _repository;

  late final ListenableSubscription _subscription;

  void _syncScopeWithState(Option<Id> id, ListenableSubscription _) {
    id.fold(_exitScope, _enterScope);
  }

  Future<void> _enterScope(Id userId) async {
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
        init: (getIt) async {
          // ==================================================================
          // DOMAIN LAYER
          // ==================================================================
          getIt.registerSingleton<Session>(credentials.session);

          // ==================================================================
          // INFRASTRUCTURE LAYER
          // ==================================================================
          getIt.registerSingletonWithDependencies(
            () => BroadcastLocalDataSource(getIt<LocalStorage>()),
            dependsOn: [LocalStorage],
          );

          getIt.registerSingletonWithDependencies(
            () => BroadcastRemoteDataSource(getIt<ApiClient>()),
            dependsOn: [ApiClient],
          );

          getIt.registerSingletonAsync<IBroadcastRepository>(() async {
            return BroadcastRepositoryImpl(
              local: getIt<BroadcastLocalDataSource>(),
              remote: getIt<BroadcastRemoteDataSource>(),
            );
          }, dependsOn: [BroadcastLocalDataSource, BroadcastRemoteDataSource]);

          // ==================================================================
          // APPLICATION LAYER
          // ==================================================================
          di.registerSingletonWithDependencies(() {
            return BroadcastFormManager(
              currentUserId: userId,
              repository: getIt<IBroadcastRepository>(),
            );
          }, dependsOn: [IBroadcastRepository]);

          di.registerSingletonWithDependencies(
            () => RecentlyLiveBroadcastsManager(getIt<IBroadcastRepository>()),
            dependsOn: [IBroadcastRepository],
          );

          di.registerSingletonWithDependencies(
            () => NowLiveBroadcastsManager(getIt<IBroadcastRepository>()),
            dependsOn: [IBroadcastRepository],
          );
        },
        dispose: () async {
          di<IBroadcastRepository>().onDispose();
          di<BroadcastFormManager>().onDispose();
          di<RecentlyLiveBroadcastsManager>().onDispose();
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
