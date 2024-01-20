part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required User? user,
    required UserToken? token,
    required AuthStatus status,
  }) = _AuthState;

  // factory AuthState.authenticated(User user, UserToken token) = _Authenticated;
  // factory AuthState.unauthenticated() = _Unauthenticated;
  // factory AuthState.partiallyAuthenticated(User user) = _PartiallyAuthenticated;

  factory AuthState.empty() {
    return const AuthState(
      user: null,
      token: null,
      status: AuthStatus.unauthenticated,
    );
  }
}

/// Enumeration representing different authentication status.
enum AuthStatus { authenticated, unauthenticated, partiallyAuthenticated }
