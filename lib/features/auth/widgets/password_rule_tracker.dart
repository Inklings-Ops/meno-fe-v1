import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/value_exception.dart';
import 'package:meno/features/auth/manager/register_form_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class PasswordRulesTracker extends WatchingWidget {
  const PasswordRulesTracker({super.key});

  static const _allRules = [
    PasswordTooShort(),
    PasswordMissingUppercase(),
    PasswordMissingLowercase(),
    PasswordMissingNumber(),
    PasswordMissingSpecialCharacter(),
  ];

  @override
  Widget build(BuildContext context) {
    final nanoStyle = MTextTheme.of(context).nanoMedium;

    final strength = watchValue((RegisterFormManager m) => m.passwordStrength);
    final strengthLabel = watchValue(
      (RegisterFormManager m) => m.passwordStrengthLabel,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedLinearProgressIndicator(value: strength),
        const SizedBox(height: Insets.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText('Your password must include:', style: nanoStyle),
            if (strengthLabel.isNotEmpty)
              MText(strengthLabel, style: nanoStyle),
          ],
        ),
        const SizedBox(height: Insets.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _allRules.map(PasswordRuleWidget.new).toList(),
        ),
      ],
    );
  }
}

class PasswordRuleWidget extends WatchingWidget {
  const PasswordRuleWidget(this.rule, {super.key});

  final ValueException<String> rule;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final brokenRules = watchValue((RegisterFormManager m) => m.passwordRules);
    final isBroken = brokenRules?.any((r) => r.runtimeType == rule.runtimeType);

    final color = brokenRules == null
        ? colors.onBackground
        : (isBroken ?? false)
        ? colors.error
        : colors.success;

    final title = rule.title;
    final subtitle = rule.subtitle;

    if (title == null || subtitle == null) return const SizedBox.shrink();

    return SizedBox(
      height: 38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MText(title, color: color, style: textTheme.subheadingMedium),
          MText(subtitle, color: color, style: textTheme.nanoMedium),
        ],
      ),
    );
  }
}

// Smooth animated progress bar
class AnimatedLinearProgressIndicator extends StatelessWidget {
  const AnimatedLinearProgressIndicator({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (_, animated, __) => LinearProgressIndicator(value: animated),
    );
  }
}
