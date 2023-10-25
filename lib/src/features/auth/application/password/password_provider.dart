import 'package:meno_design_system/meno_design_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

part 'password_provider.g.dart';

@riverpod
PasswordRule passwordRule(PasswordRuleRef ref) {
  return PasswordRule(rules: passwordStrengthRules, color: MColor.black);
}

@riverpod
IPassword password(PasswordRef ref, String input) => IPassword(input);
