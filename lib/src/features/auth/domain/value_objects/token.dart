import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_object.dart';

class Token extends ValueObject<String> {
  factory Token(String input) {
    final validationResult = _validateToken(input);
    return Token._(validationResult);
  }

  const Token._(super.value);

  static Either<ValueException<String>, String> _validateToken(String input) {
    if (input.isEmpty) {
      return Left(InvalidValueException(input, message: 'Invalid token'));
    }

    return Right(input);
  }
}
