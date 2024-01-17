import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/application.dart';

class PasswordRulesWidget extends ConsumerWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final state = ref.watch(passwordRuleProvider);

    final passwordValue = ref.watch(
      registerFormNotifierProvider.select((value) => value.passwordValue),
    );

    final password = ref.watch(passwordProvider(passwordValue));

    final length = state.rules.length;

    return Visibility(
      visible: password.get()?.isNotEmpty == true && !password.isValid(),
      child: Container(
        padding: const EdgeInsets.all(16).r,
        decoration: BoxDecoration(
          color: colorScheme.background,
          border: Border.all(width: 1.r, color: MColor.grey50),
          borderRadius: BorderRadius.circular(8).r,
        ),
        child: Wrap(
          runSpacing: 16.h,
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
    required this.rule,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final unsetColor = MColorScheme.of(context)?.error;
    final setColor = isLight ? MColor.success300 : MColor.success200;

    final ruleColor = !rule['rule'](value) ? unsetColor : setColor;

    return Visibility(
      visible: !rule['rule'](value),
      child: SizedBox(
        height: 18.h,
        width: 1.sw,
        child: MText(
          rule['name'] ?? '',
          style: MTextStyle.captionRegular,
          color: value == null ? MColor.black : ruleColor,
        ),
      ),
    );
  }
}
