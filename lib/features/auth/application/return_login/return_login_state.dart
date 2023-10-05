part of "return_login_notifier.dart";

// Represents the state of the login form.
@freezed
class ReturnLoginState with _$ReturnLoginState {
  /// Creates a new `ReturnLoginState` object.
  factory ReturnLoginState({
    /// The user's password.
    required IPassword password,

    /// Whether or not to show an error message.
    required bool showError,

    /// Whether or not the login form is loading.
    required bool loading,

    /// The result of the last login attempt.
    required Option<Either<AuthException, Unit>> option,
  }) = _ReturnLoginState;

  /// Creates a new `ReturnLoginState` object with the initial values.
  factory ReturnLoginState.initial() {
    return ReturnLoginState(
      password: IPassword(""),
      showError: false,
      loading: false,
      option: none(),
    );
  }
}
