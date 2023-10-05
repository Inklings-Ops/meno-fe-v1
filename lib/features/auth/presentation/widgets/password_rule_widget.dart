import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/password/password_provider.dart';

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    Key? key,
    required this.rule,
    required this.value,
  }) : super(key: key);

  final Map<dynamic, dynamic> rule;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final MColor? unsetColor = MColorScheme.of(context)?.error;
    final MColor setColor = isLight ? MColor.success300 : MColor.success200;

    final MColor? ruleColor = !rule['rule'](value) ? unsetColor : setColor;

    return MText(
      rule["name"] ?? "",
      style: MTextStyle.captionRegular,
      color: value == null ? MColor.black : ruleColor,
    );
  }
}

class PasswordRulesWidget extends ConsumerWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordRuleProvider);
    final password = ref.watch(passwordProvider);
    final length = state.rules.length;

    return Visibility(
      visible: password != null && password.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < length; i++) ...[
            _RuleItem(
              rule: state.rules[i],
              value: password,
            ),
            MSize.verticalSpaceMicro,
          ],
        ],
      ),
    );
  }
}
