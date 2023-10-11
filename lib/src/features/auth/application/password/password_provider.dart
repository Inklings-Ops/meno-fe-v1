import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final passwordRuleProvider = Provider.autoDispose((ref) {
  return PasswordRule(rules: passwordStrengthRules, color: MColor.black);
});

final passwordProvider = Provider.family<IPassword, String>((ref, password) {
  return IPassword(password);
});
