import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/auth/auth.dart';

final class RegisterFormManager implements Disposable {
  RegisterFormManager();

  final fullName = ValueNotifier<SingleLineString>(SingleLineString.empty);
  final email = ValueNotifier<Email>(Email.empty);
  final password = ValueNotifier<Password>(Password.emptyRegister);
  final terms = ValueNotifier<TermsAcceptance>(TermsAcceptance.empty);
  final rememberMe = ValueNotifier<bool>(false);

  late final passwordRules = password.select((pwd) {
    return pwd.input.isEmpty ? null : pwd.brokenRules.toSet();
  });

  late final passwordStrength = passwordRules.select((rules) {
    if (rules == null) return 0.0;
    const total = 5;
    return (total - rules.length) / total;
  });

  late final passwordStrengthLabel = passwordStrength.select((s) {
    if (s == 0.0) return '';
    if (s <= 0.4) return 'Weak';
    if (s <= 0.8) return 'Good';
    return 'Strong';
  });

  late final ValueListenable<bool> isValid = fullName.combineLatest4(
    email,
    password,
    terms,
    (fn, em, pw, tr) => fn.isValid && em.isValid && pw.isValid && tr.isValid,
  );

  void onFullNameChanged(String v) => fullName.value = SingleLineString(v);

  void onEmailChanged(String v) => email.value = Email(v);

  void onPasswordChanged(String v) => password.value = Password.register(v);

  void onTermsChanged(bool v) => terms.value = TermsAcceptance(v);

  void onRememberMeChanged(bool? v) => rememberMe.value = v ?? false;

  void _reset() {
    fullName.value = SingleLineString.empty;
    email.value = Email.empty;
    password.value = Password.emptyRegister;
    terms.value = TermsAcceptance.empty;
    rememberMe.value = false;
  }

  @override
  FutureOr<dynamic> onDispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    terms.dispose();
    rememberMe.dispose();
  }
}
