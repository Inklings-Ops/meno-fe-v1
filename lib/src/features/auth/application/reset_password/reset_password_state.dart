part of 'reset_password_cubit.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  factory ResetPasswordState({
    required Email email,
    required bool loading,
    required Option<Either<AuthException, Unit>> option,
  }) = _ResetPasswordState;
  factory ResetPasswordState.initial() {
    return ResetPasswordState(
      email: Email(''),
      loading: false,
      option: none(),
    );
  }
  ResetPasswordState._();
  bool get isValid => email.isValid;
}
