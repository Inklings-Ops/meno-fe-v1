import 'package:flutter/material.dart';

import '../../core/theme/styles/m_button_style.dart';
import '../loading_indicator/m_loading_indicator.dart';
import 'm_button.dart';
import 'm_button_icon_placement.dart';

class MSecondaryButton extends MButton {
  final bool loading;

  const MSecondaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    this.loading = false,
  });

  const MSecondaryButton.icon({
    super.key,
    required super.label,
    required super.icon,
    super.iconPlacement = MButtonIconPlacement.left,
    required super.onPressed,
    this.loading = false,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return OutlinedButton(
      style: MButtonStyle.of(context)?.secondary?.override(),
      onPressed: loading ? null : onPressed,
      child: loading ? const MLoadingIndicator.four(width: 56) : child,
    );
  }
}
