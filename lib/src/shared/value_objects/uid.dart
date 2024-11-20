import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_failure.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_object.dart';
import 'package:uuid/uuid.dart';

class Uid<E> extends ValueObject<String> {
  factory Uid() {
    return Uid._(right(const Uuid().v1()));
  }

  const Uid._(this.value);

  /// Used with strings we trust are unique, such as database IDs.
  factory Uid.fromString(String uniqueIdStr) {
    return Uid._(validateStringNotEmpty(uniqueIdStr));
  }
  @override
  final Either<ValueFailure<String>, String> value;
}
