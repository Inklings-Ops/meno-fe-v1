import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_shared/models/models.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';

/// Application layer manager for user-related cross-feature logic.
final class UserManager {
  const UserManager(this._auth);

  final AuthManager _auth;

  ValueListenable<Id> get currentUserId => _auth.activeUserId;

  /// The current active user entity.
  ValueListenable<User> get currentUser {
    return _auth.activeUserId.combineLatest(
      _auth.accounts,
      (id, accounts) => accounts[id]?.user ?? .empty,
    );
  }

  ValueListenable<User> get user => currentUser;

  bool get isAuthenticated => _auth.isAuthenticated;
}
