import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/_core/value_objects/value_exception.dart';
import 'package:meno/_core/value_objects/value_object.dart';

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

class MultiLineString extends ValueObject<String> {
  /// Factory accepts an optional [maxLength].
  factory MultiLineString(String input, {int? maxLength}) {
    final sanitized = input.trim();
    return MultiLineString._(_validate(sanitized, maxLength));
  }

  const MultiLineString._(super.value);

  static const MultiLineString empty = MultiLineString._(
    Left(RequiredValueException()),
  );

  static Either<ValueException<String>, String> _validate(
    String input,
    int? maxLength,
  ) {
    if (input.isEmpty) return const Left(RequiredValueException());

    if (maxLength != null && input.length > maxLength) {
      return Left(LengthExceededValueException(input, maxLength: maxLength));
    }

    return Right(input);
  }
}
