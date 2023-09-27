import 'package:flutter/material.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:meno_design_system/src/theme/m_color.dart';
import 'package:meno_design_system/src/theme/m_icons.dart';
import 'package:meno_design_system/src/theme/styles/m_text_style.dart';

import 'm_icon_button.dart';

enum _ActionButtonVariant { icon, withText }

class MBackButton extends _ActionButton {
  const MBackButton({
    super.key,
    super.onPressed,
    super.color,
  }) : super(variant: _ActionButtonVariant.icon);

  const factory MBackButton.withText({
    Key? key,
    String title,
    Color? iconColor,
    TextStyle? textStyle,
    VoidCallback? onPressed,
  }) = _MBackButtonWithText;

  const MBackButton._({
    super.key,
    super.onPressed,
    super.color,
    super.textStyle,
    super.title,
    super.variant,
  });
}

abstract class _ActionButton extends StatelessWidget {
  final _ActionButtonVariant variant;
  final VoidCallback? onPressed;
  final Color? color;
  final String title;
  final TextStyle? textStyle;

  const _ActionButton({
    super.key,
    this.variant = _ActionButtonVariant.icon,
    this.onPressed,
    this.color,
    this.title = "Back",
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final resolveColor = MInternal.resolve(isLight, MColor.black, MColor.white);
    final resolveTextStyle = MTextStyle.captionMedium.copyWith(
      color: resolveColor,
    );

    return switch (variant) {
      _ActionButtonVariant.icon => MIconButton(
          onPressed: () => _onPressed(context),
          icon: MIcons.chevron_left,
          color: color,
        ),
      _ActionButtonVariant.withText => InkWell(
          onTap: () => _onPressed(context),
          child: Row(
            children: [
              Icon(
                MIcons.chevron_left,
                color: color ?? resolveColor,
                size: 16,
              ),
              Text(title, style: textStyle ?? resolveTextStyle),
            ],
          ),
        ),
    };
  }

  void _onPressed(BuildContext context) {
    if (onPressed != null) {
      return onPressed!();
    } else {
      Navigator.maybePop(context);
    }
  }
}

class _MBackButtonWithText extends MBackButton {
  const _MBackButtonWithText({
    super.key,
    super.title = "Back",
    super.textStyle,
    super.onPressed,
    Color? iconColor,
  }) : super._(variant: _ActionButtonVariant.withText, color: iconColor);
}
