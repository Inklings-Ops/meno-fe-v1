import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

typedef NoteTitleResult = Either<ValueFailure<String>, String>;

class NoteTitle extends ValueObject<String> {
  @override
  final NoteTitleResult value;

  factory NoteTitle(String input) {
    return NoteTitle._(validateStringNotEmpty(input));
  }

  /// Creates a new `INoteTitle` object with the specified value.
  const NoteTitle._(this.value);
}
