import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

final class AuthManager extends ChangeNotifier implements Disposable {
  AuthManager(this._repository) {
    login = Command.createAsync(
      (params) async {
        final result = await _repository.login(params.email, params.password);
        return result.fold((error) => throw error, (credential) => credential);
      },
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    logout = Command.createAsyncNoParamNoResult(
      _repository.logout,
      errorFilterFn: menoExceptionFilter,
    );

    switchAccount = Command.createAsyncNoResult((userId) async {
      final result = await _repository.switchAccount(userId);
      return result.fold((error) => throw error, (_) {});
    }, errorFilterFn: menoExceptionFilter);

    addAccount = Command.createAsyncNoParamNoResult(
      _repository.clearActiveSession,
      errorFilterFn: menoExceptionFilter,
    );
  }

  final IAuthRepository _repository;

  ValueListenable<Option<Id>> get userId => _repository.activeUserId;

  ValueListenable<Map<Id, UserCredential>> get accounts => _repository.accounts;

  /// Last known user for "Welcome back" display
  /// This is populated even when session is expired
  ValueListenable<Option<User>> get lastKnownUser => _repository.lastKnownUser;

  void clearLastKnownUser() => _repository.clearLastKnownUser();

  // ======================================================================
  // COMPUTED STATE
  // ======================================================================

  /// Whether any user is authenticated
  bool get isAuthenticated => userId.value.isSome();

  late final Command<LoginParams, UserCredential> login;

  late final Command<void, void> logout;

  late final Command<Id, void> switchAccount;

  late final Command<void, void> addAccount;

  @override
  FutureOr<dynamic> onDispose() {
    logout.dispose();
    login.dispose();
    switchAccount.dispose();
    addAccount.dispose();
  }
}

final class LoginParams {
  const LoginParams(this.email, this.password);

  final Email email;
  final Password password;
}
