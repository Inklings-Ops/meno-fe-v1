import 'package:flutter/material.dart';
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
      borderColor: MColor.grey50,
      foregroundColor: MColorScheme.of(context)!.onBackground,
    );
  }
}
