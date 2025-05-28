import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AuthRedirectionText extends StatelessWidget {
  const AuthRedirectionText({
    required this.title, required this.buttonText, super.key,
    this.onPressed,
  });
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(title, style: textTheme.captionMedium),
        Spaces.horizontalMicro,
        InkWell(
          onTap: onPressed,
          child: MText(
            buttonText,
            style: textTheme.captionMedium,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
