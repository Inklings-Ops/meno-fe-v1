import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class SingleLineString extends ValueObject<String> {

  factory SingleLineString(String input) {
    final finalInput = toBeginningOfSentenceCase(input);
    return SingleLineString._(validateSingleLine(finalInput));
  }

  const SingleLineString._(this.value);
  @override
  final Either<ValueFailure<String>, String> value;
}
