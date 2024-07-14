import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/services/jwt_service.dart';

import 'password_rule.dart';
import 'value_failure.dart';

typedef ValidationResult = Either<ValueFailure<String>, String>;
typedef ValidationResultNullable = Either<ValueFailure<String?>, String?>;

ValidationResult validateEmail(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(const ValueFailure.invalidEmail());
  }
}

ValidationResult validateStringNotEmpty(String input) {
  if (input.isEmpty) {
    return left(const ValueFailure.empty());
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure.lengthExceeded(maxLength));
  }
}

ValidationResultNullable validateNullableMultiLine(
  String? input, [
  int maxLength = 244,
]) {
  if (input == null) return right(null);
  return validateMaxStringLength(input, maxLength);
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(const ValueFailure.multiline());
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  final rules = passwordStrengthRules
      .map((rule) => PasswordRule(rule['name'], rule['rule'](input)))
      .toList();

  if (rules.every((status) => status.isValid)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidPassword(rules));
  }
}

Either<ValueFailure<String>, String> validateTokenExpired(String input) {
  final jwt = JWTService();
  final isTokenExpired = jwt.isExpired(input);
  if (isTokenExpired) {
    return left(const ValueFailure.tokenExpired());
  } else {
    return right(input);
  }
}

// ValidationResult validatePassword(String input) {
//   // Must contain at least 8 characters
//   // Must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number
//   // Must contain a special character

//   const pRegEx =
//       r'''^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*[@$!%*?&]).{8,}$''';
//   if (RegExp(pRegEx).hasMatch(input)) {
//     return right(input);
//   } else {
//     return left(const ValueFailure.invalidPassword());
//   }
// }