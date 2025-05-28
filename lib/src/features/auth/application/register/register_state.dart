// ignore_for_file: unnecessary_raw_strings

part of 'register_cubit.dart';

final class RegisterState with EquatableMixin {
  RegisterState()
      : this._(
          fullName: SingleLineString.empty,
          email: Email.empty,
          password: Password.emptySignUp,
          terms: TermsCheckbox.emptyAsFalse,
        );

  const RegisterState._({
    required this.fullName,
    required this.email,
    required this.password,
    required this.terms,
    this.passwordRules,
    this.status = FormStatus.initial,
    this.rememberMe = false,
    this.exception,
  });

  RegisterState withFullName(String fullName) {
    return RegisterState._(
      fullName: SingleLineString(fullName),
      email: email,
      password: password,
      terms: terms,
      passwordRules: passwordRules,
      rememberMe: rememberMe,
    );
  }

  RegisterState withEmail(String email) {
    return RegisterState._(
      fullName: fullName,
      email: Email(email),
      password: password,
      terms: terms,
      passwordRules: passwordRules,
      rememberMe: rememberMe,
    );
  }

  RegisterState withPassword(String password) {
    return RegisterState._(
      fullName: fullName,
      email: email,
      password: Password(password, PasswordMode.signUp),
      terms: terms,
      passwordRules: _passwordErrors(password),
      rememberMe: rememberMe,
    );
  }

  RegisterState withTerms(bool terms) {
    return RegisterState._(
      fullName: fullName,
      email: email,
      password: password,
      terms: TermsCheckbox(terms),
      passwordRules: passwordRules,
      rememberMe: rememberMe,
    );
  }

  RegisterState withRememberMe(bool? rememberMe) {
    return RegisterState._(
      fullName: fullName,
      email: email,
      password: password,
      terms: terms,
      passwordRules: passwordRules,
      rememberMe: rememberMe,
    );
  }

  RegisterState withSubmissionLoading() {
    return RegisterState._(
      fullName: fullName,
      email: email,
      password: password,
      terms: terms,
      passwordRules: passwordRules,
      rememberMe: rememberMe,
      status: FormStatus.loading,
    );
  }

  RegisterState withSubmissionSuccess() {
    return RegisterState._(
      fullName: fullName,
      email: email,
      password: password,
      terms: terms,
      passwordRules: passwordRules,
      rememberMe: rememberMe,
      status: FormStatus.success,
    );
  }

  RegisterState withSubmissionFailure([AuthException? exception]) {
    return RegisterState._(
      fullName: fullName,
      email: email,
      password: password,
      terms: terms,
      passwordRules: passwordRules,
      rememberMe: rememberMe,
      status: FormStatus.failure,
      exception: exception,
    );
  }

  final SingleLineString fullName;
  final Email email;
  final Password password;
  final Set<ValueException<String>>? passwordRules;
  final TermsCheckbox terms;
  final bool? rememberMe;
  final FormStatus status;
  final AuthException? exception;

  bool get isValid =>
      fullName.isValid && email.isValid && password.isValid && terms.isValid;

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        passwordRules,
        terms,
        rememberMe,
        status,
        exception,
      ];

  /// Calculates the set of all validation rule violations (for UI tracker).
  /// This getter checks against the registration rules based on the original
  /// input, regardless of the current `mode` or `isValid` state, as the
  /// UI tracker usually displays all complexity requirements.
  Set<ValueException<String>> _passwordErrors(String input) {
    final e = <ValueException<String>>{};

    if (input.length < 8) {
      e.add(const PasswordTooShort());
    }
    if (!RegExp(r'[A-Z]').hasMatch(input)) {
      e.add(const PasswordMissingUppercase());
    }
    if (!RegExp(r'[a-z]').hasMatch(input)) {
      e.add(const PasswordMissingLowercase());
    }
    if (!RegExp(r'[0-9]').hasMatch(input)) {
      e.add(const PasswordMissingNumber());
    }
    if (!RegExp(r'[@$!%*?&]').hasMatch(input)) {
      e.add(const PasswordMissingSpecialCharacter());
    }
    return e;
  }
}
