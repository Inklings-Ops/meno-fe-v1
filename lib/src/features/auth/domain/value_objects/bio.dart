import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

/// Represents a brief bio of a Meno user
/// which is not more than `250` characters.
class Bio extends ValueObject<String> {

  /// Creates a new `IBio` object.
  factory Bio(String input) {
    return Bio._(validateMaxStringLength(input, 244));
  }

  /// Creates a new `IBio` object with the specified value.
  const Bio._(this.value);
  /// The bio, validated or not.
  @override
  final Either<ValueFailure<String>, String> value;
}
