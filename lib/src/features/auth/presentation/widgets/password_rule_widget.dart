import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/application.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

class PasswordRulesWidget extends StatelessWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final rules = PasswordRule(
      rules: passwordStrengthRules,
      color: MColor.black,
    ).rules;

    final length = rules.length;

    final bloc = context.watch<RegisterCubit>();

    return BlocSelector<RegisterCubit, RegisterState, IPassword>(
      bloc: bloc,
      selector: (state) => state.password,
      builder: (context, state) => Visibility(
        visible: state.get()?.isNotEmpty == true && !state.isValid(),
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
                _RuleItem(rule: rules[i], value: state.get()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final Map<dynamic, dynamic> rule;

  final String? value;

  const _RuleItem({required this.rule, required this.value});

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
