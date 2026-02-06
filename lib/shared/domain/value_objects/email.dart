import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';

class Email extends ValueObject<String> {
  factory Email(String input) => Email._(_validate(input));

  const Email._(super.value);

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  /// Returns a ValueObject that contains a Failure (Left).
  /// This ensures that if you accidentally try to save an empty email,
  /// .getOrCrash() will stop you.
  static const Email empty = Email._(Left(RequiredValueException()));

  static Either<ValueException<String>, String> _validate(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return const Left(RequiredValueException());

    if (!_emailRegex.hasMatch(clean)) {
      return Left(InvalidValueException(clean, msg: 'Invalid email address'));
    }

    return Right(clean);
  }
}
