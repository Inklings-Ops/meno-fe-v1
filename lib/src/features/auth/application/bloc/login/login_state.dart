part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  /// Creates a new `LoginState` object.
  const factory LoginState({
    /// The user's email address.
    required IEmail email,

    /// The user's password.
    required IPassword password,

    /// Whether or not the login form is loading.
    required bool loading,

    /// The result of the last login attempt.
    required Option<Either<AuthException, Unit>> option,
  }) = _LoginState;

  /// Creates a new `LoginFormState` object with the initial values.
  factory LoginState.initial() {
    return LoginState(
      email: IEmail(''),
      password: IPassword(''),
      loading: false,
      option: none(),
    );
  }
}
