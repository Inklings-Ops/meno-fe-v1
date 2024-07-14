import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

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
  Future<void> init();

  /// A stream of the authenticated [UserCredential]
  ///
  /// Provides a way to easy listen on for any changes made on the user's
  /// account
  Stream<UserCredential?> get userChanges;

  /// A stream of the authenticated [UserToken]
  ///
  /// Provides a way to easy listen on for any changes made on the user's token
  /// from the [UserCredential]
  Stream<Token?> get tokenChanges;

  /// Checks whether the user is currently verified.
  Future<bool> get isVerified;

  /// Gets the currently authenticated user.
  Future<User> get user;

  /// Gets the authenticated user's token.
  Token? get userToken;

  /// Gets the authenticated user's credential.
  UserCredential? get credential;

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
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  });

  /// Logs the user out.
  Future<void> logout();

  /// Registers a new user with Meno.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException` object and the right value is a `Unit` object.
  Future<Either<AuthException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    Bio? bio,
    Avatar? avatar,
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

  Future<Either<AuthException, Unit>> switchAccount(UserCredential credential);

  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required Email email,
    required String code,
  });
}
