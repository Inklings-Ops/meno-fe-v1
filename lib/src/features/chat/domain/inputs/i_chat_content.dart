import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

/// Represents a broadcast title for a Meno broadcast
class IChatContent extends ValueObject<String> {

  /// Creates a new `IBroadcastTitle` object.
  factory IChatContent(String input) {
    return IChatContent._(validateStringNotEmpty(input));
  }

  /// Creates a new `IBroadcastTitle` object with the specified value.
  const IChatContent._(this.value);
  @override
  final Either<ValueFailure<String>, String> value;
}
