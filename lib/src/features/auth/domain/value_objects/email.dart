import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:meno_fe_v1/src/core/exceptions/value_exception.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class Email extends ValueObject<String> {
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

  // --- Example of a predefined const instance ---
  // This is possible because we use the const private constructor directly
  // with a known-valid result (a Right created from a literal).
  static Email empty = Email('');
  // Example of a predefined *invalid* const instance (less common use case)
  // static const Email knownInvalid = Email._(Left(RequiredValueException()));

  // Static validation logic, separated for clarity and potential reuse
  static Either<ValueException<String>, String> _validateEmail(String input) {
    if (input.isEmpty) {
      return const Left(RequiredValueException(message: 'Email is required'));
    }

    if (!_emailRegExp.hasMatch(input)) {
      return Left(
        InvalidValueException(
          input,
          message: 'The entered email is not valid.',
        ),
      );
    }

    // Validation passed
    return Right(input);
  }
}
