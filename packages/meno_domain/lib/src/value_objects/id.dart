import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno_domain/meno_domain.dart';
import 'package:uuid/uuid.dart';

/// Unique ID value object.
final class Id extends ValueObject<String> {
  /// Factory to generate a new, unique ID (UUID v4).
  /// Assumes newly generated UUIDs are inherently valid in this context.
  factory Id() {
    // Use non-const Uuid().v4() to ensure uniqueness at runtime
    final uuidString = const Uuid().v4();
    // Directly create a Right, bypassing string validation for generated IDs
    return Id._(Right(uuidString));
  }

  /// Factory to create an Id from a string representation.
  /// Validates the input string using internal logic.
  factory Id.fromString(String input) {
    // Perform validation using the static helper method
    final validationResult = _validateString(input);
    // Create instance using the private constructor, passing the validation
    // result
    return Id._(validationResult);
  }

  const Id._(super.value);

  /// Default value for empty [Id]
  static Id empty = Id.fromString('');

  /// Static validation logic for IDs created from strings.
  static Either<ValueException<String>, String> _validateString(String input) {
    final sanitizedInput = input.trim();

    if (sanitizedInput.isEmpty) {
      return const Left(RequiredValueException(message: 'ID cannot be empty.'));
    }

    if (!Uuid.isValidUUID(fromString: sanitizedInput)) {
      return const Left(InvalidValueException(message: 'Invalid ID'));
    }

    return Right(sanitizedInput);
  }
}
