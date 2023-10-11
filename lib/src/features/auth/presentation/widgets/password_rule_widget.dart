import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/application.dart';

class PasswordRulesWidget extends ConsumerWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;
    final state = ref.watch(passwordRuleProvider);
    final password = ref.watch(
      passwordProvider(ref.watch(registerFormProvider).passwordValue),
    );
    final length = state.rules.length;

    return Visibility(
      visible: password.get()?.isNotEmpty == true && !password.isValid(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.background,
          border: Border.all(width: 1, color: MColor.grey50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Wrap(
          runSpacing: 16,
          children: [
            for (var i = 0; i < length; i++) ...[
              _RuleItem(
                rule: state.rules[i],
                value: password.get(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final Map<dynamic, dynamic> rule;

  final String? value;
  const _RuleItem({
    Key? key,
    required this.rule,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final MColor? unsetColor = MColorScheme.of(context)?.error;
    final MColor setColor = isLight ? MColor.success300 : MColor.success200;

    final MColor? ruleColor = !rule['rule'](value) ? unsetColor : setColor;

    return Visibility(
      visible: !rule["rule"](value),
      child: SizedBox(
        height: 18,
        width: double.infinity,
        child: MText(
          rule["name"] ?? "",
          style: MTextStyle.captionRegular,
          color: value == null ? MColor.black : ruleColor,
        ),
      ),
    );
  }
}
