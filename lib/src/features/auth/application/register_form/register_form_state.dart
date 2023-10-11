part of 'register_form_notifier.dart';

// Represents the state of the registration form.
@freezed
class RegisterFormState with _$RegisterFormState {
  factory RegisterFormState({
    /// The user's full name - First and Last names.
    required IFullName fullName,

    /// The user's email address.
    required IEmail email,

    /// The user's password.
    required IPassword password,

    required String passwordValue,

    /// Whether or not to show an error message.
    required bool showError,

    /// Whether or not the registration form is loading.
    required bool loading,

    /// The result of the last registration attempt.
    required Option<Either<AuthException, Unit>> option,

    required bool rememberMe,
  }) = _RegisterFormState;

  /// Creates a new `RegisterFormState` object with the initial values.
  factory RegisterFormState.initial() {
    return RegisterFormState(
      fullName: IFullName(""),
      email: IEmail(""),
      password: IPassword(""),
      passwordValue: "",
      showError: false,
      loading: false,
      option: none(),
      rememberMe: false,
    );
  }
}
