import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException {
  const factory AuthException.message(String message) = AuthExceptionMessage;
  const factory AuthException.invalidEmailOrPassword() = InvalidEmailOrPassword;
  const factory AuthException.unableToVerifyEmail() = UnableToVerifyEmail;
  const factory AuthException.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthException.serverError() = AuthServerError;
  const factory AuthException.unknownError() = AuthUnknownError;
  const factory AuthException.timeOutError() = AuthTimeOutError;
  const factory AuthException.networkError() = AuthNetworkError;
  const factory AuthException.userTokenExpired() = UserTokenExpired;
  const factory AuthException.noUserAccountFound() = NoUserAccountFound;
}
