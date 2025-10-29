import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:meno_domain/meno_domain.dart';

/// Value object for simple one line strings
class SingleLineString extends ValueObject<String> {
  /// Factory constructor: Validates eagerly and creates the instance.
  factory SingleLineString(String input) {
    final sanitizedInput = toBeginningOfSentenceCase(input.trim());
    final validationResult = _validateString(sanitizedInput);
    return SingleLineString._(validationResult);
  }

  const SingleLineString._(super.value);

  /// Empty value object
  static SingleLineString empty = SingleLineString('');

  static Either<ValueException<String>, String> _validateString(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());

    if (input.contains('\n')) {
      return Left(MaxLinesExceededValueException(input));
    }

    return Right(input);
  }
}
