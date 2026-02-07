import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// The reactive source of truth for the application's authentication state.
///
/// Design Philosophy:
/// - Repository defines "what" and "where" of data (contracts)
/// - Infrastructure defines "how" (implementation details)
/// - Uses reactive primitives for zero-latency UI updates
abstract interface class IAuthRepository {
  // ========================================================================
  // REACTIVE STATE
  // ========================================================================

  /// The current authenticated user session.
  ///
  /// - `Some(credential)`: User is authenticated
  /// - `None()`: User is not authenticated
  ///
  /// Use with `watch_it` for automatic UI rebuilds:
  /// ```dart
  /// final auth = watchIt<IAuthRepository>().authState.value;
  /// ```
  ValueListenable<Option<UserCredential>> get authState;

  /// All stored user accounts (for multi-account support).
  ///
  /// Key: User ID
  /// Value: Stored credential
  ValueListenable<Map<Id, UserCredential>> get storedAccounts;

  /// Synchronous access to current credential.
  Option<UserCredential> get currentCredential => authState.value;

  /// Whether the current user's email is verified.
  /// Returns `false` if no user is authenticated.
  bool get isEmailVerified {
    return currentCredential.match(() => false, (cred) => cred.user.verified);
  }

  // ========================================================================
  // INITIALIZATION
  // ========================================================================

  /// Checks for existing authentication on app startup.
  ///
  /// - Validates stored tokens
  /// - Refreshes if needed
  /// - Updates [authState] accordingly
  ///
  /// Call this once in your app initialization (e.g., AppManager.init()).
  Future<void> initialize();

  // ========================================================================
  // AUTHENTICATION ACTIONS
  // ========================================================================

  /// Authenticates user with email and password.
  ///
  /// On success:
  /// - Returns authenticated [UserCredential]
  /// - Updates [authState]
  /// - Stores credential in secure storage
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  });

  /// Registers a new user account.
  ///
  /// On success:
  /// - Returns the new [UserCredential]
  /// - Does NOT automatically authenticate (user must verify email first)
  /// - Triggers OTP email send
  Future<Either<AuthException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    required TermsAcceptance terms,
    MultiLineString? bio,
    ImageInput? avatar,
  });

  /// Authenticates or registers via Google OAuth.
  ///
  /// Auto-registers if user doesn't exist.
  /// On success, updates [authState] and stores credential.
  Future<Either<AuthException, UserCredential>> googleSignIn();

  /// Clears current session.
  ///
  /// - Removes tokens from storage
  /// - Updates [authState] to `None()`
  /// - Does NOT remove account from [storedAccounts] (use [removeAccount])
  Future<void> logout();

  // ========================================================================
  // EMAIL VERIFICATION & PASSWORD RECOVERY
  // ========================================================================

  /// Sends a one-time password to the user's email.
  ///
  /// [type]: Purpose of OTP (e.g., "email_verification", "password_reset")
  Future<Either<AuthException, Unit>> requestOtp({
    required Email email,
    required OtpType type,
  });

  /// Verifies user's email with OTP code.
  ///
  /// On success, updates user's verification status.
  Future<Either<AuthException, Unit>> verifyEmail({
    required Email email,
    required String code,
  });

  /// Resets password using OTP verification.
  ///
  /// Flow:
  /// 1. User requests OTP via [requestOtp]
  /// 2. User receives code via email
  /// 3. User submits code + new password here
  Future<Either<AuthException, Unit>> resetPassword({
    required Email email,
    required String code,
    required Password newPassword,
  });

  /// Changes password for authenticated user.
  ///
  /// Requires current password for security.
  Future<Either<AuthException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  });

  // ========================================================================
  // MULTI-ACCOUNT MANAGEMENT
  // ========================================================================

  /// Switches to a previously stored account.
  ///
  /// - Validates stored token
  /// - Refreshes if expired
  /// - Updates [authState]
  Future<Either<AuthException, Unit>> switchAccount(Id userId);

  /// Permanently removes an account from local storage.
  ///
  /// If the removed account is currently active, logs out.
  Future<void> removeAccount(Id userId);
}

// ========================================================================
// SUPPORTING TYPES
// ========================================================================

/// Enumeration of OTP purposes for type safety.
enum OtpType {
  emailVerification('email_verification'),
  passwordReset('password_reset');

  const OtpType(this.value);

  final String value;
}
