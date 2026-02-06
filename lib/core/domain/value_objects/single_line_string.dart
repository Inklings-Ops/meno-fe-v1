import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/core/domain/value_objects/value_exception.dart';
import 'package:meno/core/domain/value_objects/value_object.dart';

class SingleLineString extends ValueObject<String> {
  factory SingleLineString(String input) {
    final clean = input.trim();
    return SingleLineString._(_validate(clean));
  }

  const SingleLineString._(super.value);

  static const SingleLineString empty = SingleLineString._(
    Left(RequiredValueException()),
  );

  static Either<ValueException<String>, String> _validate(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());

    if (input.contains('\n')) {
      return Left(MaxLinesExceededValueException(input, 1));
    }

    return Right(input);
  }
}
