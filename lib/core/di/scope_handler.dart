import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
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
          getIt.registerSingleton<Session>(credentials.session);
        },
        dispose: () async {},
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
