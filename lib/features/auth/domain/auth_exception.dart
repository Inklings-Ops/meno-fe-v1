import 'package:meno/core/exceptions/meno_exception.dart';

sealed class AuthException extends MenoException {
  const AuthException(super.message);
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid email or password.');
}

class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException() : super('Please verify your email first.');
}

class UserBannedException extends AuthException {
  const UserBannedException() : super('This account has been suspended.');
}
