import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

typedef INoteTitleResult = Either<ValueFailure<String>, String>;

class INoteTitle extends ValueObject<String> {
  @override
  final INoteTitleResult value;

  factory INoteTitle(String input) {
    final finalInput = input.toLowerCase().trim();
    return INoteTitle._(validateNotEmpty(finalInput));
  }

  /// Creates a new `INoteTitle` object with the specified value.
  const INoteTitle._(this.value);
}
