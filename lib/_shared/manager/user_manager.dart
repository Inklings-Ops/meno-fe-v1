import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_shared/model/entities/user.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';
import 'package:meno/features/auth/model/model.dart';

final class UserManager {
  const UserManager(this._auth);

  final AuthManager _auth;

  ValueListenable<Id> get currentUserId => _auth.activeUserId;

  ValueListenable<Map<Id, UserCredential>> get accounts => _auth.accounts;

  ValueListenable<User> get lastKnownUser => _auth.lastKnownUser;

  bool get isAuthenticated => _auth.activeUserId.value.isValid;

  ValueListenable<UserCredential> get currentCredential {
    return _auth.activeUserId.combineLatest(
      _auth.accounts,
      (id, accounts) => accounts[id] ?? UserCredential.empty,
    );
  }

  ValueListenable<User> get currentUser {
    return _auth.activeUserId.combineLatest(
      _auth.accounts,
      (id, accounts) => accounts[id]?.user ?? .empty,
    );
  }
}
