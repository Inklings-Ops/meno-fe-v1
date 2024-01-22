part of '../auth_old/auth_notifier.dart';

/// The state representation of the authentication status and related data.
///
/// [AuthState] is used to manage the authentication state within the
/// application. It provides information about the user's authentication status,
/// user data, authentication tokens, user credentials, and more.
@freezed
class AuthState with _$AuthState {
  /// Creates an instance of [AuthState].
  ///
  /// Use this constructor to create an [AuthState] with specific values for
  /// status, user, token, credentials, loading state, and an option that may
  /// hold authentication-related exceptions or success values.
  factory AuthState({
    /// The authentication status.
    required AuthStatus status,

    /// The user information.
    required User user,

    /// The authentication token.
     UserToken? token,

    /// User credentials.
    required Map<String, UserCredential> credentials,

    /// Loading state indicator.
    required bool loading,

    /// Exception or success option
    required Option<Either<AuthException, Unit>> option,
  }) = _AuthState;

  /// Creates an initial [AuthState].
  ///
  /// Use this factory constructor to create an initial [AuthState] with default
  /// values. It sets the status to unauthenticated, user data to empty, and
  /// initializes the other fields to their default values.
  factory AuthState.initial() {
    return AuthState(
      credentials: {},
      option: none(),
      token: null,
      user: User.empty(),
      loading: false,
      status: AuthStatus.unauthenticated,
    );
  }

 
}
