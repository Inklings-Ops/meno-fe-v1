import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../../../shared/value_objects/value_objects.dart';

/// A typedef representing the result of validating a full name.
typedef IFullNameResult = Either<ValueFailure<String>, String>;

/// Represents a full name of a Meno user.
class IFullName extends ValueObject<String> {
  /// The full name, validated or not.
  @override
  final IFullNameResult value;

  /// Creates a new `IFullName` object.
  factory IFullName(String input) {
    final finalInput = toBeginningOfSentenceCase(input);
    return IFullName._(validateNotEmpty(finalInput));
  }

  /// Creates a new `IFullName` object with the specified value.
  const IFullName._(this.value);
}
