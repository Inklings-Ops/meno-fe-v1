import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AuthRedirectionText extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;

  const AuthRedirectionText({
    super.key,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(title, style: MTextStyle.captionMedium),
        MSize.horizontalSpaceMicro,
        InkWell(
          onTap: onPressed,
          child: MText(
            buttonText,
            style: MTextStyle.captionMedium,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
