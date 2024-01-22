import 'package:dartz/dartz.dart';

import 'entities/entities.dart';
import 'exceptions/auth_exception.dart';
import 'inputs/inputs.dart';

// Manages authentication processes, acting as a gateway between the application and authentication services.
//
// Implements the IAuthFacade interface, providing methods for:
// - Initializing authentication
// - Retrieving user credentials, token, and information
// - Handling login, registration, logout, password reset, account switching, and OTP/email verification
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
  /// Initializes the facade by retrieving the store user credential from
  /// the secure local storage and passing it on to the required stream
  /// controllers for use
  Future<void> get init;

  /// A stream of the authenticated [UserCredential]
  ///
  /// Provides a way to easy listen on for any changes made on the user's
  /// account
  Stream<UserCredential?> get userChanges;

  /// Checks whether the user is currently verified.
  Future<bool> get isVerified;

  /// Gets the currently authenticated user.
  Future<User> get user;

  /// Gets the authenticated user's token.
  Future<UserToken?> get userToken;

  /// Gets the authenticated user's credential.
  Future<UserCredential?> get credential;

  /// Gets the user's token.
  Future<Map<String, UserCredential>?> get allCredentials;

  /// Signs the user in with Google.
  ///
  /// If the user is not registered with Meno, they will be automatically registered.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException` object and the right value is a `Unit` object.
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false});

  bool isTokenExpired(String token);

  /// Logs the user in with their email address and password.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException` object and the right value is a `Unit` object.
  Future<Either<AuthException, Unit>> login({
    required IEmail email,
    required IPassword password,
  });

  /// Logs the user out.
  Future<void> logout();

  /// Performs a partial logout, which means that the user's token is invalidated but their account data is still stored on the local device.
  ///
  /// This is useful for cases where the user wants to switch to a different account without having to completely log out.
  Future<void> partialLogout();

  /// Registers a new user with Meno.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException` object and the right value is a `Unit` object.
  Future<Either<AuthException, Unit>> register({
    required IFullName fullName,
    required IEmail email,
    required IPassword password,
    IBio? bio,
    IAvatar? avatar,
  });

  Future<Either<AuthException, Unit>> changePassword({
    required IPassword currentPassword,
    required IPassword newPassword,
  });

  Future<Either<AuthException, Unit>> forgotPassword(IEmail email);

  Future<Either<AuthException, Unit>> requestOtp({
    required IEmail email,
    required String type,
  });

  Future<Either<AuthException, Unit>> resetPassword({
    required IEmail email,
    required String code,
    required IPassword newPassword,
  });

  Future<Either<AuthException, Unit>> switchAccount(UserCredential credentials);

  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required IEmail email,
    required String code,
  });
}
