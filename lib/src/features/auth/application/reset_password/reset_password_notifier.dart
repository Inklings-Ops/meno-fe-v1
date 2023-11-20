import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/domain.dart';
import '../auth/auth_notifier.dart';

part 'reset_password_notifier.freezed.dart';
part 'reset_password_notifier.g.dart';
part 'reset_password_state.dart';

@riverpod
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  @override
  ResetPasswordState build() => ResetPasswordState.initial();

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

  Future<void> onForgotPasswordPressed() async {
    final isEmailValid = state.email.isValid();

    if (isEmailValid) {
      state = state.copyWith(loading: true, option: none());

      final result =
          await ref.read(authFacadeProvider).forgotPassword(state.email);

      state = state.copyWith(loading: false, option: some(result));
    }
  }
}
