import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

/// Represents a broadcast title for a Meno broadcast
class IBroadcastTitle extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  /// Creates a new `IBroadcastTitle` object.
  factory IBroadcastTitle(String input) {
    return IBroadcastTitle._(validateNotEmpty(input));
  }

  /// Creates a new `IBroadcastTitle` object with the specified value.
  const IBroadcastTitle._(this.value);
}
