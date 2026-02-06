import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/core/core.dart';

class MultiLineString extends ValueObject<String> {
  /// Factory accepts an optional [maxLength].
  /// Default is null (unlimited).
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
