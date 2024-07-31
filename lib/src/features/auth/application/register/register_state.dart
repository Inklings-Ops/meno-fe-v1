part of 'register_cubit.dart';

// Represents the state of the registration form.
@freezed
class RegisterState with _$RegisterState {

  factory RegisterState.initial() {
    return RegisterState(
      fullName: SingleLineString(''),
      email: Email(''),
      password: Password(''),
      loading: false,
      option: none(),
      rememberMe: false,
    );
  }
  factory RegisterState({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    required bool loading,
    required Option<Either<AuthException, UserCredential>> option,
    required bool rememberMe,
  }) = _RegisterState;
  
  RegisterState._();
  bool get isFormValid => fullName.isValid && email.isValid && password.isValid;
}
