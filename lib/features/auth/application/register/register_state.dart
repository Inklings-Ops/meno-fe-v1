part of 'register_notifier.dart';

// Represents the state of the registration form.
@freezed
class RegisterState with _$RegisterState {
  factory RegisterState({
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
  }) = _RegisterState;

  /// Creates a new `RegisterState` object with the initial values.
  factory RegisterState.initial() {
    return RegisterState(
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
