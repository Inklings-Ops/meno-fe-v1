import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException {
  const factory AuthException.message(String message) = _Message;
  const factory AuthException.invalidEmailOrPassword() = InvalidEmailOrPassword;
  const factory AuthException.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthException.serverError() = ServerError;
}
