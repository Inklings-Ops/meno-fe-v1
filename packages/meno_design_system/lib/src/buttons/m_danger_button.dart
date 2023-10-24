import 'package:flutter/material.dart';

import '../theme/styles/m_button_styles.dart';
import 'm_button.dart';
import 'm_button_icon_placement.dart';

class MDangerButton extends MButton {
  const MDangerButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.style,
  });

  const MDangerButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
    super.style,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return FilledButton(
      style: MButtonStyles.of(context)?.danger?.merge(style),
      onPressed: onPressed,
      child: child,
    );
  }
}
