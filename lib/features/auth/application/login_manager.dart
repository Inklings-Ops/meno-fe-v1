import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/shared.dart';

final class LoginParams {
  const LoginParams(this.email, this.password);

  final Email email;
  final Password password;
}

final class LoginManager implements Disposable {
  LoginManager(this._repository) {
    _lastKnownUserSubscription = _repository.lastKnownUser.listen(
      (_, _) => _onLastKnownUserChanged,
    );
    _onLastKnownUserChanged();
  }

  final IAuthRepository _repository;

  late final ListenableSubscription _lastKnownUserSubscription;

  final email = ValueNotifier<Email>(Email.empty);

  final password = ValueNotifier<Password>(Password.emptyLogin);

  /// Tracks if user has manually edited the email field
  final _emailManuallyEdited = ValueNotifier<bool>(false);

  void emailChanged(String input) {
    _emailManuallyEdited.value = true; // User is typing
    email.value = Email(input);
  }

  void passwordChanged(String input) {
    password.value = Password.login(input);
  }

  /// Last known user for "Welcome back" display
  /// This is populated even when session is expired
  ValueListenable<Option<User>> get lastKnownUser => _repository.lastKnownUser;

  /// Whether we're in "password only" mode (user exists but session expired)
  ValueListenable<bool> get isPasswordOnly {
    return _repository.lastKnownUser.map((userOption) => userOption.isSome());
  }

  late final login = Command.createAsyncNoParam<UserCredential?>(() async {
    // Get the email to use for login
    final emailToUse = _getEmailForLogin();
    final result = await _repository.login(emailToUse, password.value);
    return result.fold((failure) => throw failure, (credential) => credential);
  }, initialValue: null);

  // Combine email and password validation in the DATA LAYER
  late final isValid = email.combineLatest3(password, lastKnownUser, (
    emailValue,
    passwordValue,
    lastKnownUserValue,
  ) {
    return lastKnownUserValue.match(
      // New user mode: Both email and password must be valid
      () => email.value.isValid && password.value.isValid,
      // Password-only mode: Only password needs to be valid
      (_) => password.value.isValid,
    );
  });

  /// Auto-populate email when lastKnownUser changes
  void _onLastKnownUserChanged() {
    _repository.lastKnownUser.value.match(
      () {
        // No lastKnownUser - clear email if not manually edited
        if (!_emailManuallyEdited.value) {
          email.value = Email.empty;
        }
      },
      (user) {
        // Has lastKnownUser - auto-fill email if not manually edited
        if (!_emailManuallyEdited.value) {
          email.value = user.email;
        }
      },
    );
  }

  /// Get the email to use for login
  Email _getEmailForLogin() {
    return lastKnownUser.value.match(
      // No lastKnownUser - use typed email
      () => email.value,
      // Has lastKnownUser - use their email (ignore any typed email)
      (user) => user.email,
    );
  }

  /// Reset to new user mode (used when switching away from password-only)
  void resetToNewUser() {
    _emailManuallyEdited.value = false;
    email.value = Email.empty;
    password.value = Password.emptyLogin;
  }

  @override
  FutureOr<dynamic> onDispose() {
    _lastKnownUserSubscription.cancel();
    email.dispose();
    password.dispose();
    _emailManuallyEdited.dispose();
    login.dispose();
  }
}
