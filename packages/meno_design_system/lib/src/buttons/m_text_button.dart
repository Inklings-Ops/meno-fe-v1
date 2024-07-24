import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTextButton extends MButton {
  const MTextButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.style,
  });

  const MTextButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
    super.style,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return TextButton(
      style: style?.merge(MButtonStyles.of(context)?.text),
      onPressed: onPressed,
      child: child,
    );
  }
}
