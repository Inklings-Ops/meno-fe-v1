import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart' show MenoException;
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// The reactive source of truth for the application's authentication state.
///
/// Design Philosophy:
/// - Repository defines "what" and "where" of data (contracts)
/// - Infrastructure defines "how" (implementation details)
/// - Uses reactive primitives for zero-latency UI updates
abstract interface class IAuthRepository implements Disposable {
  /// The active Identity. The Router watches THIS.
  ///
  /// - Immutable (String ID).
  /// - Only changes on Login, Logout, or Switch.
  /// - Does NOT change when User data (bio, name) changes.
  ValueListenable<Option<Id>> get activeUserId;

  /// The Data Vault. The UI watches THIS.
  ///
  /// Contains all logged-in sessions.
  /// UI widgets find their specific user here using the [activeUserId].
  ValueListenable<Map<Id, UserCredential>> get accounts;

  /// Helper: Synchronously looks up the Active User in the Vault.
  Option<UserCredential> get currentCredential;

  /// Last known user (even if session expired)
  /// This is used for "Welcome back" UI when session expires
  ValueListenable<Option<User>> get lastKnownUser;

  /// Clears the last known user (even if session expired)
  void clearLastKnownUser();

  /// Hydrates the Vault and sets the Active Anchor.
  Future<void> initialize([UserCredential? refreshed]);

  /// Whether the current user's email is verified.
  /// Returns `false` if no user is authenticated.
  bool get isEmailVerified {
    return currentCredential.match(() => false, (cred) => cred.user.verified);
  }

  // ========================================================================
  // AUTHENTICATION ACTIONS
  // ========================================================================

  /// Authenticates user with email and password.
  ///
  /// On success:
  /// - Returns authenticated [UserCredential]
  /// - Updates [activeUserId]
  /// - Stores credential in secure storage
  Future<Either<MenoException, UserCredential>> login(
    Email email,
    Password password,
  );

  /// Registers a new user account.
  ///
  /// On success:
  /// - Returns the new [UserCredential]
  /// - Does NOT automatically authenticate (user must verify email first)
  /// - Triggers OTP email send
  Future<Either<MenoException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    required TermsAcceptance terms,
  });

  /// Authenticates or registers via Google OAuth.
  ///
  /// Auto-registers if user doesn't exist.
  /// On success, updates [activeUserId] and stores credential.
  Future<Either<MenoException, UserCredential>> googleSignIn();

  /// Clears current session.
  ///
  /// - Removes tokens from storage
  /// - Updates [activeUserId] to `None()`
  Future<void> logout();

  // ========================================================================
  // EMAIL VERIFICATION & PASSWORD RECOVERY
  // ========================================================================

  /// Sends a one-time password to the user's email.
  ///
  /// [type]: Purpose of OTP (e.g., "email_verification", "password_reset")
  Future<Either<MenoException, Unit>> requestOtp({
    required Email email,
    required OtpType type,
  });

  /// Verifies user's email with OTP code.
  ///
  /// On success, updates user's verification status.
  Future<Either<MenoException, Unit>> verifyEmail({
    required Email email,
    required String code,
  });

  /// Resets password using OTP verification.
  ///
  /// Flow:
  /// 1. User requests OTP via [requestOtp]
  /// 2. User receives code via email
  /// 3. User submits code + new password here
  Future<Either<MenoException, Unit>> resetPassword({
    required Email email,
    required String code,
    required Password newPassword,
  });

  /// Changes password for authenticated user.
  ///
  /// Requires current password for security.
  Future<Either<MenoException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  });

  // ========================================================================
  // MULTI-ACCOUNT MANAGEMENT
  // ========================================================================

  /// Switches the [activeUserId] to a different account in the Vault.
  Future<Either<MenoException, Unit>> switchAccount(Id userId);

  /// Permanently removes an account from local storage.
  ///
  /// If the removed account is currently active, logs out.
  Future<void> removeAccount(Id userId);

  Future<void> clearActiveSession();
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
