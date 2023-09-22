import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'm_button_icon_placement.dart';
import 'm_button_text.dart';

abstract class MButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final MButtonIconPlacement iconPlacement;
  final VoidCallback? onPressed;

  const MButton({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
  }) : this._(key: key, label: label, onPressed: onPressed);

  const MButton.icon({
    Key? key,
    required String label,
    required IconData icon,
    MButtonIconPlacement iconPlacement = MButtonIconPlacement.left,
    required VoidCallback? onPressed,
  }) : this._(
          key: key,
          onPressed: onPressed,
          label: label,
          icon: icon,
          iconPlacement: iconPlacement,
        );

  const MButton._({
    super.key,
    required this.label,
    this.icon,
    this.iconPlacement = MButtonIconPlacement.left,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (icon != null) {
      child = _MButtonWithIcon(
        iconPlacement: iconPlacement,
        icon: icon!,
        label: label,
      );
    } else {
      child = MButtonText(label: label);
    }

    return buildButton(context, child);
  }

  Widget buildButton(BuildContext context, Widget child);
}

class _MButtonWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final MButtonIconPlacement iconPlacement;

  const _MButtonWithIcon({
    required this.icon,
    required this.label,
    required this.iconPlacement,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.textScaleFactorOf(context);
    final gap = SizedBox(
      width: scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (iconPlacement == MButtonIconPlacement.left) ...[Icon(icon), gap],
        Flexible(child: MButtonText(label: label)),
        if (iconPlacement == MButtonIconPlacement.right) ...[gap, Icon(icon)],
      ],
    );
  }
}
