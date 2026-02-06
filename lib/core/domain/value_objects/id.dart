import 'package:fpdart/fpdart.dart';
import 'package:meno/core/domain/value_objects/value_objects.dart';
import 'package:uuid/uuid.dart';

class Id extends ValueObject<String> {
  /// Creates a valid, unique UUID v4.
  /// We verify this is valid by definition, so we skip validation logic.
  factory Id.unique() => Id._(Right(const Uuid().v4()));

  /// Validates a string input.
  factory Id.fromString(String input) => Id._(_validate(input));

  const Id._(super.value);

  /// Failed ID to handle specific empty logic
  static const Id empty = Id._(Left(RequiredValueException(msg: 'Invalid ID')));

  /// Validation Logic
  static Either<ValueException<String>, String> _validate(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return const Left(RequiredValueException<String>());

    try {
      if (!Uuid.isValidUUID(fromString: clean)) {
        return Left(InvalidValueException(clean, msg: 'Invalid format'));
      }
    } catch (_) {
      return Left(InvalidValueException(clean, msg: 'Invalid format'));
    }

    return Right(clean);
  }
}
