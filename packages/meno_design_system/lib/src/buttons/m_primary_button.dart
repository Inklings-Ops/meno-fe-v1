import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MPrimaryButton extends MButton {
  final bool loading;
  final bool disabled;

  const MPrimaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    this.disabled = false,
    this.loading = false,
    super.style,
  });

  const MPrimaryButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
    this.loading = false,
    this.disabled = false,
    super.style,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return ElevatedButton(
      style: style ?? MButtonStyles.of(context)?.primary?.merge(style),
      onPressed: (loading || disabled) ? null : onPressed,
      child: loading ? const MLoadingIndicator.four(width: 56) : child,
    );
  }
}
