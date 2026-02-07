import 'package:fpdart/fpdart.dart';
import 'package:meno/core/exceptions/meno_exception.dart';

sealed class AuthException extends MenoException {
  const AuthException(super.message, [super.code]);
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

// This allows you to convert a NetworkException into an AuthException
class AuthSystemFailure extends AuthException {
  const AuthSystemFailure(super.message, [super.code]);

  // Factory to convert generic MenoException to AuthSystemFailure
  factory AuthSystemFailure.fromMeno(MenoException e) {
    return AuthSystemFailure(e.message, e.code);
  }
}

extension AuthEitherX<R> on Either<MenoException, R> {
  /// Maps generic MenoExceptions to specific AuthExceptions
  Either<AuthException, R> mapToAuthException() {
    return mapLeft((menoError) {
      // Pass through if it's already an AuthException (Safety check)
      if (menoError is AuthException) return menoError;

      // Handle specific Server Messages (if your API returns specific strings)
      if (menoError.message.contains('Invalid credentials')) {
        return const InvalidCredentialsException();
      }

      if (menoError.message.contains('verify')) {
        return const EmailNotVerifiedException();
      }

      // Fallback: Wrap everything else (Network, Server, Timeout)
      // into a generic Auth failure.
      return AuthSystemFailure.fromMeno(menoError);
    });
  }
}
