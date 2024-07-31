import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_rule.freezed.dart';

List<Map<String, dynamic>> passwordStrengthRules = [
  {
    'name': 'A minimum of 8 characters',
    'rule': (String text) => RegExp('.{8,}').hasMatch(text),
  },
  {
    'name': 'At least one capital letter',
    'rule': (String text) => RegExp('(?=.*[A-Z])').hasMatch(text),
  },
  {
    'name': 'At least one number',
    'rule': (String text) => RegExp('(?=.*[0-9])').hasMatch(text),
  },
  {
    'name': 'At least one special character',
    'rule': (String text) => RegExp(r'(?=.*[@$!%*?&])').hasMatch(text),
  },
];

@freezed
class PasswordRule with _$PasswordRule {
  factory PasswordRule({
    required String title,
    required bool isValid,
  }) = _PasswordRule;
}
