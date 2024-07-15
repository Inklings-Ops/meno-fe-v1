import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class PasswordRulesWidget extends StatelessWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return BlocSelector<RegisterCubit, RegisterState, Password>(
      bloc: context.watch<RegisterCubit>(),
      selector: (state) => state.password,
      builder: (context, state) => Visibility(
        visible: !state.isValid,
        child: Container(
          padding: const EdgeInsets.all(16).r,
          decoration: BoxDecoration(
            color: colors.background,
            border: Border.all(width: 1.r, color: MColor.grey50),
            borderRadius: BorderRadius.circular(8).r,
          ),
          child: Wrap(
            runSpacing: 16.h,
            children: state.value.fold(
              (failure) => failure.maybeWhen(
                orElse: () => passwordStrengthRules.map((e) {
                  final rule = PasswordRule(e['name'], false);
                  return _RuleItem(rule: rule, color: colors.onBackground);
                }).toList(),
                invalidPassword: (rules) => rules.map((rule) {
                  if (rule == null) return const SizedBox();
                  return _RuleItem(rule: rule);
                }).toList(),
              ),
              (_) => [],
            ),
          ),
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({required this.rule, this.color});
  final PasswordRule rule;
  final MColor? color;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final unsetColor = MColorScheme.of(context)?.error;
    final setColor = isLight ? MColor.success300 : MColor.success200;

    final ruleColor = !rule.isValid ? unsetColor : setColor;

    return Visibility(
      visible: !rule.isValid,
      child: SizedBox(
        height: 18.h,
        width: 1.sw,
        child: MText(
          rule.title,
          style: MTextStyle.captionRegular,
          color: color ?? ruleColor,
        ),
      ),
    );
  }
}
