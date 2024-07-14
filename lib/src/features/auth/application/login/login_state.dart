part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  /// Creates a new `LoginState` object.
  factory LoginState({
    /// The user's email address.
    required Email email,

    /// The user's password.
    required Password password,

    /// Whether or not the login form is loading.
    required bool loading,

    /// The result of the last login attempt.
    required Option<Either<AuthException, UserCredential>> option,
  }) = _LoginState;

  LoginState._();

  bool get isFormValid => email.isValid && password.isValid;

  /// Creates a new `LoginFormState` object with the initial values.
  factory LoginState.initial() {
    return LoginState(
      email: Email(''),
      password: Password(''),
      loading: false,
      option: none(),
    );
  }
}
