import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

/// A typedef representing the result of validating a password.
typedef IPasswordResult = Either<ValueFailure<String>, String>;

/// Represents a password of a Meno user
class Password extends ValueObject<String> {

  /// Creates a new `IPassword` object.
  factory Password(String input, {bool isLogin = false}) {
    if (isLogin) {
      return Password._(
        validateStringNotEmpty(input.trim()),
        isLogin: isLogin,
      );
    } else {
      return Password._(
        validateStringNotEmpty(input.trim()).flatMap(validatePassword),
        isLogin: isLogin,
      );
    }
  }

  /// Creates a new `IPassword` object with the specified value and isLogin flag.
  const Password._(this.value, {this.isLogin = false});
  /// The password, validated or not.
  @override
  final IPasswordResult value;

  /// Whether the password is for signing in or signing up.
  final bool isLogin;
}
