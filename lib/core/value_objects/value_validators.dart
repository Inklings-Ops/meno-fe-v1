import 'package:dartz/dartz.dart';

import 'value_failure.dart';

Either<ValueFailure<String>, String> validateBioLength(String input) {
  if (input.length > 250) {
    return left(ValueFailure.bioLengthExceeded(input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateEmail(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(input));
  } else {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    if (RegExp(emailRegex).hasMatch(input)) {
      return right(input);
    } else {
      return left(ValueFailure.invalidEmail(input));
    }
  }
}

Either<ValueFailure<String>, String> validateNotEmpty(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  // Must contain at least 8 characters
  // Must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number
  // Must contain a special character
  if (input.isEmpty) {
    return left(ValueFailure.empty(input));
  } else {
    const pRegEx =
        r"""^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*[@$!%*?&]).{8,}$""";
    if (RegExp(pRegEx).hasMatch(input)) {
      return right(input);
    } else {
      return left(ValueFailure.invalidPassword(input));
    }
  }
}
