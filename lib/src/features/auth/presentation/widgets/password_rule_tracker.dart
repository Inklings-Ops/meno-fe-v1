import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class PasswordRulesWidgetTracker extends StatelessWidget {
  const PasswordRulesWidgetTracker({super.key});
  @override
  Widget build(BuildContext context) {
    final nanoStyle = MTextTheme.of(context).nanoMedium;
    const errors = [
      PasswordTooShort(),
      PasswordMissingUppercase(),
      PasswordMissingLowercase(),
      PasswordMissingNumber(),
      PasswordMissingSpecialCharacter(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LinearProgressIndicator(value: 0),
        const SizedBox(height: Insets.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText('Your password must include:', style: nanoStyle),
            MText('Good', style: nanoStyle),
          ],
        ),
        const SizedBox(height: Insets.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: errors.map(PasswordRuleWidget.new).toList(),
        ),
      ],
    );
  }
}

class PasswordRuleWidget extends StatelessWidget {
  const PasswordRuleWidget(this.error, {super.key});
  final ValueException<String> error;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final rules = context.select((RegisterCubit b) => b.state.passwordRules);

    final isCurrentError = rules?.contains(error) ?? false;

    final title = error.title;
    final subtitle = error.subtitle;
    final color = rules == null
        ? colors.onBackground
        : isCurrentError
            ? colors.error
            : colors.success;

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
