import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno_domain/meno_domain.dart';

/// Value object for strings with more than one line
final class MultiLineString extends ValueObject<String> {
  /// Factory constructor: Validates eagerly and creates the instance.
  factory MultiLineString(String value) {
    final validationResult = _validateString(value);
    return MultiLineString._(validationResult);
  }

  const MultiLineString._(super.value);

  /// Default class for use with empty values
  static MultiLineString empty = MultiLineString('');

  static Either<ValueException<String>, String> _validateString(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());
    if (input.length > 244) return Left(LengthExceededValueException(input));
    return Right(input);
  }
}
