import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:meno_fe_v1/src/core/exceptions/value_exception.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class SingleLineString extends ValueObject<String> {
  factory SingleLineString(String input) {
    final sanitizedInput = toBeginningOfSentenceCase(input.trim());
    final validationResult = _validateString(sanitizedInput);
    return SingleLineString._(validationResult);
  }

  const SingleLineString._(super.value);

  static SingleLineString empty = SingleLineString('');

  static Either<ValueException<String>, String> _validateString(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());

    if (input.contains('\n')) {
      return Left(MaxLinesExceededValueException(input, 1));
    }

    return Right(input);
  }
}
