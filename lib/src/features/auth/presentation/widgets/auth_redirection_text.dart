import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AuthRedirectionText extends StatelessWidget {
  const AuthRedirectionText({
    super.key,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(title, style: $styles.text.captionMedium),
        $styles.spaces.horizontalMicro,
        InkWell(
          onTap: onPressed,
          child: MText(
            buttonText,
            style: $styles.text.captionMedium,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
