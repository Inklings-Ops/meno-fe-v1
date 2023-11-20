import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MSecondaryButton extends MButton {
  final bool loading;

  const MSecondaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    this.loading = false,
    super.style,
  });

  const MSecondaryButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
    this.loading = false,
    super.style,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return OutlinedButton(
      style: style ?? MButtonStyles.of(context)?.secondary,
      onPressed: loading ? null : onPressed,
      child: loading ? const MLoadingIndicator.four(width: 56) : child,
    );
  }
}
