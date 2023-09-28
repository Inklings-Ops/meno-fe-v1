import 'package:dartz/dartz.dart';

import 'entities/entities.dart';
import 'exceptions/auth_exception.dart';
import 'inputs/inputs.dart';

/// Meno Authentication Facade
abstract class IAuthFacade {
  /// Checks whether the user is currently verified.
  Future<bool> get isVerified;

  /// Gets the user's token.
  Future<UserToken> get userToken;

  /// Gets the current user.
  Future<User> getUser();

  /// Signs the user in with Google.
  ///
  /// If the user is not registered with Meno, they will be automatically registered.
  ///
  /// Returns an `Either` value, where the left value is a `AuthException` object and the right value is a `Unit` object.
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false});

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
}
