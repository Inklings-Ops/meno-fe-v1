import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/theme/styles/m_button_style.dart';

import 'm_button.dart';
import 'm_button_icon_placement.dart';

class MTextButton extends MButton {
  const MTextButton({
    super.key,
    required super.label,
    required super.onPressed,
  });

  const MTextButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return TextButton(
      style: MButtonStyle.of(context)?.text?.override(),
      onPressed: onPressed,
      child: child,
    );
  }
}
