import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:meno_fe_v1/src/core/exceptions/value_exception.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show ValueObject;

class MultiLineString extends ValueObject<String> {
  factory MultiLineString(String input) {
    final validationResult = _validateString(input);
    return MultiLineString._(validationResult);
  }

  const MultiLineString._(super.input);

  static MultiLineString empty = MultiLineString('');

  static Either<ValueException<String>, String> _validateString(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());
    if (input.length > 244) return Left(LengthExceededValueException(input));
    return Right(input);
  }
}
