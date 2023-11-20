import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MGoogleButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const MGoogleButton({super.key, this.title = "Google", this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MSecondaryButton.icon(
      label: title,
      icon: Assets.images.google.svg(),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.50.r, color: MColor.grey50),
        foregroundColor: MColorScheme.of(context)!.onBackground,
      ),
    );
  }
}
