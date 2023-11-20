import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

/// Represents a broadcast title for a Meno broadcast
class IChatContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  /// Creates a new `IBroadcastTitle` object.
  factory IChatContent(String input) {
    return IChatContent._(validateNotEmpty(input));
  }

  /// Creates a new `IBroadcastTitle` object with the specified value.
  const IChatContent._(this.value);
}
