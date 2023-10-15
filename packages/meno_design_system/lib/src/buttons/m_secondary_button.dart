import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MSecondaryButton extends MButton {
  final bool loading;
  final MColor? borderColor;
  final MColor? foregroundColor;
  final double? borderRadius;

  const MSecondaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    this.loading = false,
    this.borderColor,
    this.foregroundColor,
    this.borderRadius,
  });

  const MSecondaryButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
    this.loading = false,
    this.borderColor,
    this.foregroundColor,
    this.borderRadius,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor != null ? foregroundColor! : null,
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 1.50)
            : null,
        shape: borderRadius != null
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
              )
            : null,
      ),
      onPressed: loading ? null : onPressed,
      child: loading ? const MLoadingIndicator.four(width: 56) : child,
    );
  }
}
