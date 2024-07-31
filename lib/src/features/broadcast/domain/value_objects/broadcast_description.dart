import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

/// Represents a broadcast description for a Meno broadcast
class BroadcastDescription extends ValueObject<String?> {

  /// Creates a new `IBroadcastDescription` object.
  factory BroadcastDescription(String? input) {
    return BroadcastDescription._(validateNullableMultiLine(input));
  }

  /// Creates a new `IBroadcastDescription` object with the specified value.
  const BroadcastDescription._(this.value);
  @override
  final Either<ValueFailure<String?>, String?> value;
}
