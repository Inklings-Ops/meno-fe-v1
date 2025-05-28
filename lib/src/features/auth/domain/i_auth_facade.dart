import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/core/exceptions/auth_exception.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

// Manages authentication processes, acting as a gateway between the
// application and authentication services.
//
// Implements the IAuthFacade interface, providing methods for:
// - Initializing authentication
// - Retrieving user credentials, token, and information
// - Handling login, registration, logout, password reset, account switching,
//   and OTP/email verification
//
// Relies on:
// - AuthMapper: Converts data between domain models and data source models.
// - AuthRemoteDatasource: Interacts with remote authentication services.
// - AuthLocalDatasource: Manages local storage of authentication data.
// - NetworkService: Checks network connectivity.
// - JWTService: Handles JWT token operations.
//
// Registers as a singleton using the `@LazySingleton` annotation.
abstract class IAuthFacade {
  /// Returns all the [UserCredential]s of stored in the app secure storage.
  Stream<Map<String, UserCredential>> get allAccounts;

  /// A stream of the authenticated [UserCredential]
  ///
  /// Provides a way to easy listen on for any changes made on the user's
  /// account
  Stream<UserCredential?> get userChanges;

  /// Checks whether the user is currently verified.
  Future<bool> get isVerified;

  UserCredential? get credential;

  /// Signs the user in with Google.
  ///
  /// If the user is not registered with Meno, they will be automatically
  /// registered.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException`
  /// object and the right value is a `Unit` object.
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false});

  /// Logs the user in with their email address and password.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException`
  /// object and the right value is a `Unit` object.
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  });

  /// Logs the user out.
  Future<void> logout();

  /// Registers a new user with Meno.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException`
  /// object and the right value is a `Unit` object.
  Future<Either<AuthException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    MultiLineString? bio,
    ImageFile? avatar,
  });

  Future<Either<AuthException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  });

  Future<Either<AuthException, Unit>> forgotPassword(Email email);

  Future<Either<AuthException, Unit>> requestOtp({
    required Email email,
    required String type,
  });

  Future<Either<AuthException, Unit>> resetPassword({
    required Email email,
    required String code,
    required Password newPassword,
  });

  Future<void> removeAccount(ID id);

  Future<Either<AuthException, Unit>> switchAccount(UserCredential credential);

  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required Email email,
    required String code,
  });
}
