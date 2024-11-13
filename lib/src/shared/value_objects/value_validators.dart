import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/services/jwt_service.dart';
import 'package:meno_fe_v1/src/shared/value_objects/password_rule.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_failure.dart';

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
  final rules = passwordStrengthRules.map(
    (r) {
      final title = r['name'] as String;
      final isValidFunc = r['rule'] as bool Function(String);
      return PasswordRule(title: title, isValid: isValidFunc(input));
    },
  ).toList();

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
