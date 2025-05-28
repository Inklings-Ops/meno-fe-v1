sealed class ValueException<T> implements Exception {
  const ValueException({required this.code, required this.message});

  final String code;
  final String message;
}

final class UnexpectedValueException<T> extends ValueException<T> {
  const UnexpectedValueException({
    super.code = 'unexpected',
    super.message = 'An unexpected exception occurred.',
  });
}

final class RequiredValueException<T> extends ValueException<T> {
  const RequiredValueException({
    super.code = 'required-value',
    super.message = 'This value cannot be empty.',
  });
}

final class InvalidValueException<T> extends ValueException<T> {
  const InvalidValueException(
    this.value, {
    super.code = 'invalid-value',
    super.message = 'Invalid value.',
  });

  final T value;
}

final class LengthExceededValueException<T> extends ValueException<T> {
  const LengthExceededValueException(
    this.value, {
    this.maxLength = 244,
    super.code = 'length-exceeded',
    super.message = 'Value length exceeded.',
  });

  final T value;
  final int maxLength;
}

final class MaxLinesExceededValueException<T> extends ValueException<T> {
  const MaxLinesExceededValueException(
    this.value,
    this.maxLines, {
    super.code = 'max-lines-exceeded',
    super.message = 'Number of valid lines has been exceeded.',
  });

  final T value;
  final int maxLines;
}

final class InvalidFileFormatException<T> extends ValueException<T> {
  const InvalidFileFormatException(
    this.value, {
    super.code = 'invalid-format',
    super.message = 'The file format selected is invalid.',
  });

  final T value;
}

final class PasswordTooShort extends ValueException<String> {
  const PasswordTooShort({
    super.code = 'too-short',
    super.message = 'Password must be at least 8 characters',
  });
}

final class PasswordMissingLowercase extends ValueException<String> {
  const PasswordMissingLowercase({
    super.code = 'missing-lowercase',
    super.message = 'Please include a lowercase letter in your password',
  });
}

final class PasswordMissingUppercase extends ValueException<String> {
  const PasswordMissingUppercase({
    super.code = 'missing-uppercase',
    super.message = 'Please include a uppercase letter in your password',
  });
}

final class PasswordMissingSpecialCharacter extends ValueException<String> {
  const PasswordMissingSpecialCharacter({
    super.code = 'missing-special-character',
    super.message = 'Please include a special character in your password',
  });
}

final class PasswordMissingNumber extends ValueException<String> {
  const PasswordMissingNumber({
    super.code = 'missing-number',
    super.message = 'Please include a number in your password',
  });
}
