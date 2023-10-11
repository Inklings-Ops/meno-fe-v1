import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

/// A typedef representing the result of validating a bio.
typedef IBioResult = Either<ValueFailure<String>, String>;

/// Represents a brief bio of a Meno user
/// which is not more than `250` characters.
class IBio extends ValueObject<String> {
  /// The bio, validated or not.
  @override
  final IBioResult value;

  /// Creates a new `IBio` object.
  factory IBio(String input) {
    return IBio._(validateBioLength(input));
  }

  /// Creates a new `IBio` object with the specified value.
  const IBio._(this.value);
}
