import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:meno_fe_v1/src/core/exceptions/value_exception.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class TermsCheckbox extends ValueObject<bool> {
  factory TermsCheckbox(bool input) {
    final validationResult = _validateBool(input);
    return TermsCheckbox._(validationResult);
  }

  const TermsCheckbox._(super.input);

  static TermsCheckbox emptyAsFalse = TermsCheckbox(false);

  static Either<ValueException<bool>, bool> _validateBool(bool input) {
    if (!input) {
      return const Left(
        RequiredValueException(message: 'Please accept the Terms of Service'),
      );
    }

    return Right(input);
  }
}
