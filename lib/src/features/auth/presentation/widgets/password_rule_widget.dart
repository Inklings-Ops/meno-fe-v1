import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

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
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: colors.background,
            border: Border.all(color: MColor.grey50),
            borderRadius: Corners.sm,
          ),
          child: Wrap(
            runSpacing: 16,
            children: state.value.fold(
              (failure) => failure.maybeWhen(
                orElse: () => passwordStrengthRules.map((e) {
                  final title = e['name'] as String;
                  final rule = PasswordRule(title: title, isValid: false);
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
    final textTheme = MTextTheme.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final unsetColor = MColorScheme.of(context)?.error;
    final setColor = isLight ? MColor.success300 : MColor.success200;
    final ruleColor = !rule.isValid ? unsetColor : setColor;
    return Visibility(
      visible: !rule.isValid,
      child: SizedBox(
        height: 18,
        width: MediaQuery.sizeOf(context).width,
        child: MText(
          rule.title,
          style: textTheme.captionRegular,
          color: color ?? ruleColor,
        ),
      ),
    );
  }
}
