import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_exception.freezed.dart';

///Value Exception
@freezed
sealed class ValueException<T> with _$ValueException<T> implements Exception {
  /// Value Exception
  const factory ValueException({
    required String code,
    required String message,
  }) = _ValueException;

  const factory ValueException.unexpected({
    @Default('unexpected') String code,
    @Default('An unexpected exception occurred.') String message,
  }) = UnexpectedValueException<T>;

  const factory ValueException.required({
    @Default('required-value') String code,
    @Default('This value is required') String message,
  }) = RequiredValueException<T>;

  const factory ValueException.invalid({
    @Default('invalid-value') String code,
    @Default('Invalid value') String message,
  }) = InvalidValueException<T>;

  const factory ValueException.lengthExceeded(
    T value, {
    @Default(244) int maxLength,
    @Default('length-exceeded') String code,
    @Default('Value length exceeded.') String message,
  }) = LengthExceededValueException<T>;

  const factory ValueException.maxLinesExceeded(
    T value, {
    @Default('max-lines-exceeded') String code,
    @Default('Number of valid lines has been exceeded.') String message,
  }) = MaxLinesExceededValueException<T>;

  const factory ValueException.invalidFileFormat(
    T value, {
    @Default('invalid-format') String code,
    @Default('The file format selected is invalid.') String message,
  }) = InvalidFileFormatException<T>;

  const factory ValueException.fileTooLarge({
    @Default('file-too-large') String code,
    @Default('The file provided is too large. (Max 10MB)') String message,
  }) = FileTooLargeException<T>;

  const factory ValueException.fileNotFound({
    @Default('file-not-found') String code,
    @Default('File not found.') String message,
  }) = FileNotFoundException<T>;

  const factory ValueException.passwordTooShort({
    @Default('too-short') String code,
    @Default('Password must be at least 8 characters') String message,
  }) = PasswordTooShort<T>;

  const factory ValueException.passwordMissingLowercase({
    @Default('missing-lowercase') String code,
    @Default('Please include a lowercase letter in your password')
    String message,
  }) = PasswordMissingLowercase<T>;

  const factory ValueException.passwordMissingUppercase({
    @Default('missing-uppercase') String code,
    @Default('Please include a uppercase letter in your password')
    String message,
  }) = PasswordMissingUppercase<T>;

  const factory ValueException.passwordMissingSpecialCharacter({
    @Default('missing-special-character') String code,
    @Default('Please include a special character in your password')
    String message,
  }) = PasswordMissingSpecialCharacter<T>;

  const factory ValueException.passwordMissingNumber({
    @Default('missing-number') String code,
    @Default('Please include a number in your password') String message,
  }) = PasswordMissingNumber<T>;
}
