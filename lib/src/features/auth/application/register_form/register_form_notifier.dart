import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../dependency_injector/injector.dart';
import '../../domain/domain.dart';

part 'register_form_notifier.freezed.dart';
part 'register_form_state.dart';

/// A state notifier provider for the registration form.
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
  (ref) => RegisterFormNotifier(di<IAuthFacade>()),
);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  /// The auth facade dependency.
  final IAuthFacade _authFacade;

  /// Creates a new `RegisterFormNotifier` object.
  RegisterFormNotifier(this._authFacade) : super(RegisterFormState.initial());

  @override
  void dispose() {
    state = RegisterFormState.initial();
    super.dispose();
  }

  /// Updates the user's email address.
  ///
  /// Args:
  ///   email: The user's new email address.
  void emailChanged(String email) {
    /// Creates a new `IEmail` object from the given email address.
    final IEmail iEmail = IEmail(email);

    /// Updates the state with the new email address and clears the `option`.
    state = state.copyWith(email: iEmail, option: none());
  }

  /// Updates the user's full name
  ///
  /// Args:
  ///   email: The user's new full name
  void fullNameChanged(String value) {
    /// Creates a new `IFullName` object from the given full name
    final IFullName iFullName = IFullName(value);

    /// Updates the state with the new full name and clears the `option`.
    state = state.copyWith(fullName: iFullName, option: none());
  }

  void onRememberMeChanged(bool? value) {
    state = state.copyWith(rememberMe: value ?? state.rememberMe);
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String value) {
    /// Creates a new `IPassword` object from the given password.
    final IPassword iPassword = IPassword(value);

    /// Updates the state with the new password and clears the `option`.
    state = state.copyWith(
      password: iPassword,
      option: none(),
      passwordValue: value,
    );
  }

  /// Initiates the registration process.
  ///
  /// Returns:
  ///   A `Future` that completes when the registration process is finished.
  Future<void> registerPressed() async {
    /// Checks if the full name, email and password are valid.
    final isFullNameValid = state.fullName.isValid();
    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.isValid();

    /// If the full name, email and password are valid, attempt to register
    /// the new user.
    if (isFullNameValid && isEmailValid && isPasswordValid) {
      /// Updates the state to indicate that the login process is in progress.
      state = state.copyWith(loading: true, option: none());

      /// Calls the `register()` method on the `_authFacade` object to attempt
      /// to register the new user.
      final Either<AuthException, Unit> result = await _authFacade.register(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
      );

      /// Updates the state with the result of the registration attempt.
      state = state.copyWith(loading: false, option: some(result));
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
      (error) => error.mapOrNull(
        empty: (_) => 'Full Name is required',
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
        invalidPassword: (value) => 'Please, type in a valid password',
      ),
      (_) => null,
    );
  }
}
