import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/shared/value_objects/password_rule.dart';

part 'value_failure.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.empty() = Empty<T>;
  const factory ValueFailure.invalidEmail() = InvalidEmail<T>;
  const factory ValueFailure.invalidImageType() = InvalidImageType<T>;
  const factory ValueFailure.invalidPassword(List<PasswordRule?> rules) = InvalidPassword<T>;
  const factory ValueFailure.multiline() = Multiline<T>;
  const factory ValueFailure.lengthExceeded(int max) = LengthExceeded<T>;
  const factory ValueFailure.tokenExpired() = TokenExpired<T>;
}
