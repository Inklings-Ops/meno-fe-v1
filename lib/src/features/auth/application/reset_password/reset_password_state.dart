part of 'reset_password_cubit.dart';

final class ResetPasswordState with EquatableMixin {
  ResetPasswordState() : this._(email: Email(''));

  const ResetPasswordState._({
    required this.email,
    this.status = FormStatus.initial,
    this.exception,
  });

  ResetPasswordState withEmail(String email) {
    return ResetPasswordState._(email: Email(email));
  }

  ResetPasswordState withSubmissionLoading() {
    return ResetPasswordState._(
      email: email,
      status: FormStatus.loading,
    );
  }

  ResetPasswordState withSubmissionSuccess() {
    return ResetPasswordState._(
      email: email,
      status: FormStatus.success,
    );
  }

  ResetPasswordState withSubmissionFailure([AuthException? exception]) {
    return ResetPasswordState._(
      email: email,
      status: FormStatus.failure,
      exception: exception,
    );
  }

  final Email email;
  final FormStatus status;
  final AuthException? exception;

  bool get isValid => email.isValid;

  @override
  List<Object?> get props => [email, status, exception];
}
