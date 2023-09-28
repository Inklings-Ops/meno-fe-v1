import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/core/value_objects/value_failure.dart';
import 'package:meno_fe_v1/core/value_objects/value_object.dart';
import 'package:meno_fe_v1/core/value_objects/value_validators.dart';

/// A typedef representing the result of validating a password.
typedef IPasswordResult = Either<ValueFailure<String>, String>;

/// Represents a password of a Meno user
class IPassword extends ValueObject<String> {
  /// The password, validated or not.
  @override
  final IPasswordResult value;

  /// Whether the password is for signing in or signing up.
  final bool isSignIn;

  /// Creates a new `IPassword` object.
  factory IPassword(String input, {bool isSignIn = false}) {
    if (isSignIn) {
      return IPassword._(validateNotEmpty(input.trim()), isSignIn: isSignIn);
    } else {
      return IPassword._(validatePassword(input.trim()), isSignIn: isSignIn);
    }
  }

  /// Creates a new `IPassword` object with the specified value and isSignIn flag.
  const IPassword._(this.value, {this.isSignIn = false});
}
