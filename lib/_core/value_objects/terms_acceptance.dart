import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/_core/value_objects/value_exception.dart';
import 'package:meno/_core/value_objects/value_object.dart';

class TermsAcceptance extends ValueObject<bool> {
  factory TermsAcceptance(bool input) => TermsAcceptance._(_validate(input));

  const TermsAcceptance._(super.value);

  static const TermsAcceptance empty = TermsAcceptance._(
    Left(RequiredValueException()),
  );

  static Either<ValueException<bool>, bool> _validate(bool input) {
    if (input == false) {
      return const Left(
        RequiredValueException<bool>(
          msg: 'You must accept the Terms of Service to continue.',
        ),
      );
    }

    return Right(input);
  }
}
