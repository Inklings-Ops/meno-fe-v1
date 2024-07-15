import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

/// A typedef representing the result of validating an email address.
typedef IEmailResult = Either<ValueFailure<String>, String>;

/// Represents an email address of a Meno user
class Email extends ValueObject<String> {
  /// The email address, validated or not.
  @override
  final IEmailResult value;

  /// Creates a new `IEmail` object.
  factory Email(String input) {
    final finalInput = input.toLowerCase().trim();
    return Email._(validateEmail(finalInput).flatMap(validateStringNotEmpty));
  }

  /// Creates a new `IEmail` object with the specified value.
  const Email._(this.value);
}
