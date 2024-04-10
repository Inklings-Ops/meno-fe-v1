import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

typedef INoteContentResult = Either<ValueFailure<String>, String>;

class INoteContent extends ValueObject<String> {
  @override
  final INoteContentResult value;

  factory INoteContent(String input) {
    final finalInput = input.toLowerCase().trim();
    return INoteContent._(validateNotEmpty(finalInput));
  }

  /// Creates a new `INoteContent` object with the specified value.
  const INoteContent._(this.value);
}
