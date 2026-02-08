import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

final class AuthManager extends ChangeNotifier implements Disposable {
  AuthManager(this._repository) {
    login = Command.createAsync((params) async {
      final result = await _repository.login(params.email, params.password);
      return result.fold((error) => throw error, (credential) => credential);
    }, initialValue: UserCredential.empty);

    logout = Command.createAsyncNoParamNoResult(_repository.logout);
  }

  final IAuthRepository _repository;

  ValueListenable<Option<Id>> get userId => _repository.activeUserId;

  // ======================================================================
  // COMPUTED STATE
  // ======================================================================

  /// Whether any user is authenticated
  bool get isAuthenticated => userId.value.isSome();

  /// Current active credential (if authenticated)
  Option<UserCredential> get credential => _repository.currentCredential;

  /// All available accounts for switching
  Map<Id, UserCredential> get availableAccounts => _repository.accounts.value;

  /// Last known user for "Welcome back" display
  /// This is populated even when session is expired
  ValueListenable<Option<User>> get lastKnownUser => _repository.lastKnownUser;

  late final Command<LoginParams, UserCredential> login;

  late final Command<void, void> logout;

  @override
  FutureOr<dynamic> onDispose() {
    logout.dispose();
    login.dispose();
  }
}

final class LoginParams {
  const LoginParams(this.email, this.password);

  final Email email;
  final Password password;
}
