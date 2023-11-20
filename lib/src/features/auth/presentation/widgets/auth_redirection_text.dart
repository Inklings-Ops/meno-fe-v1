import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final colorScheme = MColorScheme.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(title, style: MTextStyle.captionMedium),
        MCore.micro.horizontalSpace,
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
