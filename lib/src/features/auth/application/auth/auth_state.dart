part of 'auth_bloc.dart';

// Represents the authentication state of the user.
@freezed
class AuthState with _$AuthState {
/// User is fully authenticated and has all necessary credentials.
  const factory AuthState.authenticated(UserCredential credentials) =
      _Authenticated;

/// User has provided some credentials but requires further verification or actions.
  const factory AuthState.partiallyAuthenticated(UserCredential credentials) =
      _PartiallyAuthenticated;

/// User is not authenticated.
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
