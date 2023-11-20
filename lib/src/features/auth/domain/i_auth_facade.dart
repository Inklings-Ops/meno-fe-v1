import 'package:dartz/dartz.dart';

import 'entities/entities.dart';
import 'exceptions/auth_exception.dart';
import 'inputs/inputs.dart';

/// Meno Authentication Facade
abstract class IAuthFacade {
  /// Checks whether the user is currently authenticated or logged in.
  ///
  /// In this case, both the `UserToken` and `User` details must securely saved.
  Future<bool> get isAuthenticated;

  /// Checks whether the user is currently partially authenticated or logged in.
  ///
  /// In this case, just the `User` details are securely saved and the token is
  /// removed.
  Future<bool> get isPartiallyAuthenticated;

  /// Checks whether the user is currently verified.
  Future<bool> get isVerified;

  /// Gets the current user.
  Future<User?> get user;

  /// Gets the user's token.
  Future<UserToken?> get userToken;

  Future<Either<AuthException, Unit>> changePassword({
    required IPassword currentPassword,
    required IPassword newPassword,
  });

  Future<Either<AuthException, Unit>> forgotPassword(IEmail email);

  Future<Map<String, UserCredentials>?> getAllUserCredentials();

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
  Future<Either<AuthException, UserCredentials>> login({
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

  Future<Either<AuthException, Unit>> requestOtp({
    required IEmail email,
    required String type,
  });

  Future<Either<AuthException, Unit>> resetPassword({
    required IEmail email,
    required String code,
    required IPassword newPassword,
  });

  Future<Either<AuthException, Unit>> switchAccount(
      UserCredentials credentials);

  
  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required IEmail email,
    required String code,
  });
}
