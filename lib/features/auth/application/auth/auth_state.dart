part of 'auth_notifier.dart';

@freezed
class AuthState with _$AuthState {
  factory AuthState({
    required AuthStatus status,
    required User user,
    required UserToken token,
    required Map<String, UserCredentials> credentials,
    required bool loading,
    required Option<Either<AuthException, Unit>> option,
  }) = _AuthState;

  factory AuthState.initial() {
    return AuthState(
      credentials: {},
      option: none(),
      token: "",
      user: User.empty(),
      loading: false,
      status: AuthStatus.unauthenticated,
    );
  }
}
