import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

typedef NoteContentResult = Either<ValueFailure<String>, String>;

class NoteContent extends ValueObject<String> {

  factory NoteContent(String input) {
    return NoteContent._(validateStringNotEmpty(input));
  }

  /// Creates a new `INoteContent` object with the specified value.
  const NoteContent._(this.value);
  @override
  final NoteContentResult value;
}
