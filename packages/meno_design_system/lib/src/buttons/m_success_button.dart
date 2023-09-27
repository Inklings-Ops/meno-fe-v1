import 'package:flutter/material.dart';
import 'package:meno_design_system/src/theme/styles/m_button_style.dart';

import 'm_button.dart';
import 'm_button_icon_placement.dart';

class MSuccessButton extends MButton {
  const MSuccessButton({
    super.key,
    required super.label,
    required super.onPressed,
  });

  const MSuccessButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return FilledButton(
      style: MButtonStyle.of(context)?.success?.override(),
      onPressed: onPressed,
      child: child,
    );
  }
}
