part of 'login_cubit.dart';

final class LoginState with EquatableMixin {
  LoginState() : this._(email: Email(''), password: Password(''));

  const LoginState._({
    required this.email,
    required this.password,
    this.status = FormStatus.initial,
    this.exception,
  });

  LoginState withEmail(String email) {
    return LoginState._(email: Email(email), password: password);
  }

  LoginState withPassword(String password) {
    return LoginState._(email: email, password: Password(password));
  }

  LoginState withSubmissionLoading() {
    return LoginState._(
      email: email,
      password: password,
      status: FormStatus.loading,
    );
  }

  LoginState withSubmissionSuccess() {
    return LoginState._(
      email: email,
      password: password,
      status: FormStatus.success,
    );
  }

  LoginState withSubmissionFailure([AuthException? exception]) {
    return LoginState._(
      email: email,
      password: password,
      status: FormStatus.failure,
      exception: exception,
    );
  }

  final Email email;
  final Password password;
  final FormStatus status;
  final AuthException? exception;

  bool get isValid => email.isValid && password.isValid;

  @override
  List<Object?> get props => [email, password, status, exception];
}
