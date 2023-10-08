part of 'login_form_notifier.dart';

// Represents the state of the login form.
@freezed
class LoginFormState with _$LoginFormState {
  /// Creates a new `LoginFormState` object.
  factory LoginFormState({
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
  }) = _LoginFormState;

  /// Creates a new `LoginFormState` object with the initial values.
  factory LoginFormState.initial() {
    return LoginFormState(
      email: IEmail(""),
      password: IPassword(""),
      showError: false,
      loading: false,
      option: none(),
    );
  }
}

