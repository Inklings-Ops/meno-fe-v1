import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MGoogleButton extends StatelessWidget {
  const MGoogleButton({super.key, required this.title, this.onPressed});
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MSecondaryButton.icon(
      label: title,
      icon: Assets.images.google.svg(),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.50.r, color: colors.inActiveContainer!),
        foregroundColor: colors.onBackground,
        backgroundColor: colors.background,
      ),
    );
  }
}
