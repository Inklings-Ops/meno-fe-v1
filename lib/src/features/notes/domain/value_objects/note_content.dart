import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

typedef NoteContentResult = Either<ValueFailure<String>, String>;

class NoteContent extends ValueObject<String> {
  @override
  final NoteContentResult value;

  factory NoteContent(String input) {
    return NoteContent._(validateNotEmpty(input));
  }

  /// Creates a new `INoteContent` object with the specified value.
  const NoteContent._(this.value);
}
