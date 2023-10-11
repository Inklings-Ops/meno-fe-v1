part of "reset_password_notifier.dart";

@freezed
class ResetPasswordState with _$ResetPasswordState {
  factory ResetPasswordState({
    required IEmail email,

    /// Whether or not to show an error message.
    required bool showError,

    /// Whether or not the login form is loading.
    required bool loading,

    /// The result of the last login attempt.
    required Option<Either<AuthException, Unit>> option,
  }) = _ResetPasswordState;

  factory ResetPasswordState.initial() {
    return ResetPasswordState(
      email: IEmail(""),
      showError: false,
      loading: false,
      option: none(),
    );
  }
}
