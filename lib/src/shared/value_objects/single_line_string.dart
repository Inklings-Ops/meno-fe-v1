import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import 'value_objects.dart';

class SingleLineString extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory SingleLineString(String input) {
    final finalInput = toBeginningOfSentenceCase(input);
    return SingleLineString._(validateSingleLine(finalInput));
  }

  const SingleLineString._(this.value);
}
