import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/shared.dart';

final class UserManager {
  const UserManager(this._repository);

  final IAuthRepository _repository;

  ValueListenable<Option<Id>> get currentUserId => _repository.activeUserId;

  /// The current active user entity.
  ///
  /// UI Widgets watch this. They don't see the Token/Session.
  /// We derive this reactively from the repository's state.
  ValueListenable<Option<User>> get currentUser {
    // We combine the Anchor (ID) with the Vault (Map)
    // to produce a stream of just the User Entity.
    return _repository.activeUserId.combineLatest(
      _repository.accounts,
      (idOption, accounts) => idOption.flatMap((id) {
        return Option.fromNullable(accounts[id]?.user);
      }),
    );
  }

  /// Helper: Get current value synchronously (useful for logic, not UI)
  User? get userOrNull => currentUser.value.fold(() => null, (user) => user);

  /// Whether active user's email is verified
  bool get isEmailVerified => _repository.isEmailVerified;
}
