import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

final class AuthManager extends ChangeNotifier implements Disposable {
  AuthManager(this._repository) {
    logout = Command.createAsyncNoParamNoResult(_repository.logout);
    _repository.activeUserId.listen((value, _) => userId.value = value);
    _repository.accounts.listen((value, _) => _accounts.value = value);
  }

  final IAuthRepository _repository;

  final userId = ValueNotifier<Option<Id>>(none());
  final _accounts = ValueNotifier<Map<Id, UserCredential>>({});

  // ======================================================================
  // COMPUTED STATE
  // ======================================================================

  /// Whether any user is authenticated
  bool get isAuthenticated => userId.value.isSome();

  /// Current active credential (if authenticated)
  Option<UserCredential> get credential => _repository.currentCredential;

  /// All available accounts for switching
  Map<Id, UserCredential> get availableAccounts => _accounts.value;

  late final Command<void, void> logout;

  @override
  FutureOr<dynamic> onDispose() {
    userId.dispose();
    _accounts.dispose();
    logout.dispose();
  }
}
