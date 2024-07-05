import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import 'value_failure.dart';
import 'value_object.dart';

class Uid<E> extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  const Uid._(this.value);

  factory Uid() {
    return Uid._(right(const Uuid().v1()));
  }

  /// Used with strings we trust are unique, such as database IDs.
  factory Uid.fromString(String uniqueIdStr) {
    return Uid._(right(uniqueIdStr));
  }
}