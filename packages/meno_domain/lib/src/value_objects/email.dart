import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno_domain/meno_domain.dart';

/// Email Value Object
final class Email extends ValueObject<String> {
  /// Public factory constructor: Performs validation EAGERLY.
  /// This constructor cannot be const because it takes runtime input.
  factory Email(String input) {
    final sanitizedInput = input.trim();

    // Call the static validation logic
    final validationResult = _validateEmail(sanitizedInput);
    // Create instance using the private const constructor, passing the result
    return Email._(validationResult);
  }

  const Email._(super.value);

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Empty [Email] value object
  static Email empty = Email('');

  // Static validation logic, separated for clarity and potential reuse
  static Either<ValueException<String>, String> _validateEmail(String input) {
    if (input.isEmpty) {
      return const Left(
        RequiredValueException(message: 'Email is required'),
      );
    }

    if (!_emailRegExp.hasMatch(input)) {
      return const Left(
        InvalidValueException(
          message: 'The entered email is not valid.',
        ),
      );
    }

    // Validation passed
    return Right(input);
  }
}
