import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/_core/_core.dart';

class Token extends ValueObject<String> {
  factory Token(String input) => Token._(_validate(input));

  factory Token.orEmpty(String? input) {
    if (input == null || input.trim().isEmpty) return Token.empty;
    return Token(input);
  }

  const Token._(super.value);

  static const Token empty = Token._(Left(RequiredValueException()));

  static Either<ValueException<String>, String> _validate(String input) {
    if (input.trim().isEmpty) {
      return const Left(RequiredValueException(msg: 'Token cannot be empty'));
    }

    return Right(input);
  }
}
