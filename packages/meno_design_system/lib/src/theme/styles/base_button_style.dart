import 'package:flutter/material.dart';
import 'package:meno_design_system/src/theme/m_theme.dart';

class BaseButtonStyle {
  final Color? background;
  final Color? backgroundPressed;
  final Color? backgroundDisabled;

  final Color? foreground;
  final Color? foregroundPressed;
  final Color? foregroundDisabled;

  final Color? borderColor;
  final Color? borderColorPressed;
  final Color? borderColorDisabled;

  final Color? iconColor;
  final Color? iconColorPressed;
  final Color? iconColorDisabled;

  BaseButtonStyle({
    this.background,
    this.backgroundPressed,
    this.backgroundDisabled,
    this.foreground,
    this.foregroundPressed,
    this.foregroundDisabled,
    this.borderColor,
    this.borderColorPressed,
    this.borderColorDisabled,
    this.iconColor,
    this.iconColorPressed,
    this.iconColorDisabled,
  });

  BaseButtonStyle copyWith({
    Color? background,
    Color? backgroundPressed,
    Color? backgroundDisabled,
    Color? foreground,
    Color? foregroundPressed,
    Color? foregroundDisabled,
    Color? borderColor,
    Color? borderColorPressed,
    Color? borderColorDisabled,
    Color? iconColor,
    Color? iconColorPressed,
    Color? iconColorDisabled,
  }) {
    return BaseButtonStyle(
      background: background ?? this.background,
      backgroundPressed: backgroundPressed ?? this.backgroundPressed,
      backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
      foreground: foreground ?? this.foreground,
      foregroundPressed: foregroundPressed ?? this.foregroundPressed,
      foregroundDisabled: foregroundDisabled ?? this.foregroundDisabled,
      borderColor: borderColor ?? this.borderColor,
      borderColorPressed: borderColorPressed ?? this.borderColorPressed,
      borderColorDisabled: borderColorDisabled ?? this.borderColorDisabled,
      iconColor: iconColor ?? this.iconColor,
      iconColorPressed: iconColorPressed ?? this.iconColorPressed,
      iconColorDisabled: iconColorDisabled ?? this.iconColorDisabled,
    );
  }

  BaseButtonStyle lerp(BaseButtonStyle? other, double t) {
    return BaseButtonStyle(
      background: Color.lerp(background, other?.background, t),
      backgroundPressed:
          Color.lerp(backgroundPressed, other?.backgroundPressed, t),
      backgroundDisabled:
          Color.lerp(backgroundDisabled, other?.backgroundDisabled, t),
      foreground: Color.lerp(foreground, other?.foreground, t),
      foregroundPressed:
          Color.lerp(foregroundPressed, other?.foregroundPressed, t),
      foregroundDisabled:
          Color.lerp(foregroundDisabled, other?.foregroundDisabled, t),
      borderColor: Color.lerp(borderColor, other?.borderColor, t),
      borderColorPressed:
          Color.lerp(borderColorPressed, other?.borderColorPressed, t),
      borderColorDisabled:
          Color.lerp(borderColorDisabled, other?.borderColorDisabled, t),
      iconColor: Color.lerp(iconColor, other?.iconColor, t),
      iconColorPressed:
          Color.lerp(iconColorPressed, other?.iconColorPressed, t),
      iconColorDisabled:
          Color.lerp(iconColorDisabled, other?.iconColorDisabled, t),
    );
  }

  ButtonStyle get toButtonStyle {
    return ButtonStyle(
      elevation: MTheme.resolveWith(defaultValue: 0),
      overlayColor: MTheme.resolveWith(
        defaultValue: background!,
        pressedValue: backgroundPressed,
      ),
      backgroundColor: MTheme.resolveWith(
        defaultValue: background!,
        pressedValue: background,
        disabledValue: backgroundDisabled,
      ),
      foregroundColor: MTheme.resolveWith(
        defaultValue: foreground!,
        pressedValue: foregroundPressed,
        disabledValue: foregroundDisabled,
      ),
      iconColor: MTheme.resolveWith(
        defaultValue: iconColor!,
        pressedValue: iconColorPressed,
        disabledValue: iconColorDisabled,
      ),
      side: borderColor == null
          ? null
          : MTheme.resolveWith(
              defaultValue: BorderSide(color: borderColor!, width: 1.50),
              pressedValue: BorderSide(color: borderColorPressed!, width: 1.50),
              disabledValue: BorderSide(color: borderColorDisabled!),
            ),
    );
  }

  ButtonStyle override([ButtonStyle? baseButtonStyle]) {
    return toButtonStyle.merge(baseButtonStyle);
  }
}

extension ButtonStyleX on BaseButtonStyle? {
  BaseButtonStyle merge(BaseButtonStyle? other) {
    if (this == null) return other ?? BaseButtonStyle();
    return this!.copyWith(
      background: this!.background ?? other?.background,
      backgroundPressed: this!.backgroundPressed ?? other?.backgroundPressed,
      backgroundDisabled: this!.backgroundDisabled ?? other?.backgroundDisabled,
      foreground: this!.foreground ?? other?.foreground,
      foregroundPressed: this!.foregroundPressed ?? other?.foregroundPressed,
      foregroundDisabled: this!.foregroundDisabled ?? other?.foregroundDisabled,
      borderColor: this!.borderColor ?? other?.borderColor,
      borderColorPressed: this!.borderColorPressed ?? other?.borderColorPressed,
      borderColorDisabled:
          this!.borderColorDisabled ?? other?.borderColorDisabled,
      iconColor: this!.iconColor ?? other?.iconColor,
      iconColorPressed: this!.iconColorPressed ?? other?.iconColorPressed,
      iconColorDisabled: this!.iconColorDisabled ?? other?.iconColorDisabled,
    );
  }
}
