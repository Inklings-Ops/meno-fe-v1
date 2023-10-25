import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../onboarding/onboarding.dart';
import '../../domain/domain.dart';
import '../auth/auth_notifier.dart';

part 'login_form_notifier.freezed.dart';
part 'login_form_notifier.g.dart';
part 'login_form_state.dart';

@riverpod
class LoginFormNotifier extends _$LoginFormNotifier {
  @override
  LoginFormState build() => LoginFormState.initial();

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

  /// Initiates the login process.
  ///
  /// Returns:
  ///   A `Future` that completes when the login process is finished.
  Future<void> loginPressed() async {
    /// Checks if the email and password are valid.
    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.get() != null;

    /// If the email and password are valid, attempts to log the user in.
    if (isEmailValid && isPasswordValid) {
      /// Updates the state to indicate that the login process is in progress.
      state = state.copyWith(loading: true, option: none());

      /// Calls the `login()` method on the `_authFacade` object to attempt to log the user in.
      final result = await ref.read(authFacadeProvider).login(
            email: state.email,
            password: state.password,
          );

      result.fold(
        (l) => null,
        (r) async {
          if (ref.read(onboardingProvider).isOnboarded() == false) {
            await ref.read(onboardingProvider).onboardingCompleted();
          }
          await ref.read(authProvider.notifier).checkAuthenticated();
        },
      );

      /// Updates the state with the result of the login attempt.
      state = state.copyWith(loading: false, option: some(result));
    }
  }

  /// Updates the user's password.
  ///
  /// Args:
  ///   password: The user's new password.
  void passwordChanged(String password) {
    /// Creates a new `IPassword` object from the given password and the `isSignIn` flag.
    final IPassword iPassword = IPassword(password, isSignIn: true);

    /// Updates the state with the new password and clears the `option`.
    state = state.copyWith(password: iPassword, option: none());
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
