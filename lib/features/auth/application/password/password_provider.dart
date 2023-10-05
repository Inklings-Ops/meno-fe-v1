import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/register/register_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/password_rule.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/password_strength_rules.dart';

final passwordRuleProvider = Provider.autoDispose((ref) {
  return PasswordRule(rules: passwordStrengthRules, color: MColor.black);
});

final passwordProvider = Provider.autoDispose<String?>(
  (ref) => ref.watch(registerProvider).passwordValue,
);
