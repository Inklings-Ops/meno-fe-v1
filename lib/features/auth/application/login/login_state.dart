part of "login_notifier.dart";

// Represents the state of the login form.
@freezed
class LoginState with _$LoginState {
  /// Creates a new `LoginState` object.
  factory LoginState({
    /// The user's email address.
    required IEmail email,

    /// The user's password.
    required IPassword password,

    /// Whether or not to show an error message.
    required bool showError,

    /// Whether or not the login form is loading.
    required bool loading,

    /// The result of the last login attempt.
    required Option<Either<AuthException, Unit>> option,
  }) = _LoginState;

  /// Creates a new `LoginState` object with the initial values.
  factory LoginState.initial() {
    return LoginState(
      email: IEmail(""),
      password: IPassword(""),
      showError: false,
      loading: false,
      option: none(),
    );
  }
}

