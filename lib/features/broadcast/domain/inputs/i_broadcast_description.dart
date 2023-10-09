import 'package:dartz/dartz.dart';

import '../../../../core/value_objects/value_objects.dart';

/// Represents a broadcast description for a Meno broadcast
class IBroadcastDescription extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  /// Creates a new `IBroadcastDescription` object.
  factory IBroadcastDescription(String input) {
    return IBroadcastDescription._(validateBroadcastDescription(input));
  }

  /// Creates a new `IBroadcastDescription` object with the specified value.
  const IBroadcastDescription._(this.value);
}
