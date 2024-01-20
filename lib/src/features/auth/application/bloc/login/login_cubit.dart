import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/domain.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@lazySingleton
class LoginCubit extends Cubit<LoginState> {
  final IAuthFacade _facade;

  LoginCubit({
    required IAuthFacade facade,
  })  : _facade = facade,
        super(LoginState.initial());

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    /// Creates a new `IEmail` object from the given email address.
    final IEmail iEmail = IEmail(email);

    /// Updates the state with the new email address and clears the `option`.
    emit(state.copyWith(email: iEmail, option: none()));
  }

  /// Initiates the login process.
  ///
  /// Returns:
  ///   A `Future` that completes when the login process is finished.
  Future<void> login() async {
    // Checks if the email and password are valid. If not, return void.
    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.get() != null;

    if (!isEmailValid && !isPasswordValid) return;

    // Show progress indicator
    emit(state.copyWith(loading: true, option: none()));

    // Calls the `login()` method on the `_authFacade` object to attempt to log the user in.
    final result = await _facade.login(
      email: state.email,
      password: state.password,
    );

    // Updates the state with the result of the login attempt.
    emit(state.copyWith(option: some(result), loading: false));
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String password) {
    /// Creates a new `IPassword` object from the given password and the `isLogin` flag.
    final IPassword iPassword = IPassword(password, isLogin: true);

    /// Updates the state with the new password and clears the `option`.
    emit(state.copyWith(password: iPassword, option: none()));
  }

  /// Validates an email address.
  ///
  /// Returns an error message if the email address is invalid, or `null` if the email address is valid.
  ///
  /// Args:
  ///   value: The email address to validate.
  ///
  /// Returns:
  ///   An error message if the email address is invalid, or `null` if the email address is valid.
  String? validateEmail(String? value) {
    return state.email.value.fold(
      (error) => error.mapOrNull(
        invalidEmail: (_) => 'Please type a valid email address',
        empty: (_) => 'Email is required',
      ),
      (_) => null,
    );
  }

  /// Validates a password.
  ///
  /// Returns an error message if the password is invalid, or `null` if the password is valid.
  ///
  /// Args:
  ///   value: The password to validate.
  ///
  /// Returns:
  ///   An error message if the password is invalid, or `null` if the password is valid.
  String? validatePassword(String? value) {
    return state.password.value.fold(
      (error) => error.mapOrNull(
        empty: (_) => 'Password is required',
      ),
      (_) => null,
    );
  }
}
