import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

/// A [Cubit] responsible for managing the registration state.
@lazySingleton
class RegisterCubit extends Cubit<RegisterState> {
  final IAuthFacade _facade;
  RegisterCubit({required IAuthFacade facade})
      : _facade = facade,
        super(RegisterState.initial());

  /// Checks if the full name, email and password are valid.
  bool get isValid {
    return state.fullName.isValid() &&
        state.email.isValid() &&
        state.password.isValid();
  }

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    /// Updates the state with the new email address and clears the `option`.
    emit(state.copyWith(email: IEmail(email), option: none()));
  }

  /// Updates the user's full name
  ///
  /// Args:
  ///   email: The user's new full name
  void fullNameChanged(String value) {
    /// Updates the state with the new full name and clears the `option`.
    emit(state.copyWith(fullName: IFullName(value), option: none()));
  }

  void onRememberMeChanged(bool? value) {
    emit(state.copyWith(rememberMe: value ?? state.rememberMe));
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String value) {
    /// Updates the state with the new password and clears the `option`.
    emit(state.copyWith(
      password: IPassword(value),
      option: none(),
      passwordValue: value,
    ));
  }

  /// Initiates the registration process.
  ///
  /// Returns:
  ///   A `Future` that completes when the registration process is finished.
  Future<void> registerPressed() async {
    /// If the full name, email and password are valid, attempt to register
    /// the new user.
    if (isValid) {
      /// Updates the state to indicate that the login process is in progress.
      emit(state.copyWith(loading: true, option: none()));

      /// Calls the `register()` method on the `_authFacade` object to attempt
      /// to register the new user.
      final result = await _facade.register(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
      );

      /// Updates the state with the result of the registration attempt.
      emit(state.copyWith(loading: false, option: some(result)));
    }
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

  /// Validates the user's full name.
  ///
  /// Args:
  ///   value: The full name to validate.
  ///
  /// Returns:
  ///   An error message if the full name is `null` and `null` if the full name is valid.
  String? validateFullName(String? value) {
    return state.fullName.value.fold(
      (error) => error.mapOrNull(empty: (_) => 'Full Name is required'),
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
        invalidPassword: (value) => 'Please, type in a valid password',
      ),
      (_) => null,
    );
  }
}
