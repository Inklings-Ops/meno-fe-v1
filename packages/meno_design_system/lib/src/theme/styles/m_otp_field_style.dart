import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';


class MOtpFieldStyles extends ThemeExtension<MOtpFieldStyles> {
  final TextStyle? textStyle;
  final MColor? textColor;
  final MColor? fillColor;
  final MColor? fillColorDisabled;
  final MColor? errorColor;
  final BoxBorder? border;
  final BoxBorder? borderFocused;
  final BoxBorder? borderError;

  MOtpFieldStyles({
    this.textStyle,
    this.textColor,
    this.fillColor,
    this.fillColorDisabled,
    this.errorColor,
    this.border,
    this.borderFocused,
    this.borderError,
  });

  factory MOtpFieldStyles.$default(MColorScheme colors) {
    return MOtpFieldStyles(
      textStyle: $styles.text.captionRegular,
      fillColor: colors.background,
      fillColorDisabled: colors.disabledContainer,
      textColor: colors.onBackground,
      errorColor: colors.error,
      border: Border.all(color: MColor.grey50, width: 1.toScale),
      borderFocused: Border.all(color: colors.outline!, width: 2.toScale),
      borderError: Border.all(color: colors.error!, width: 2.toScale),
    );
  }

  static MOtpFieldStyles? of(BuildContext context) {
    return Theme.of(context).extension<MOtpFieldStyles>();
  }

  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  @override
  ThemeExtension<MOtpFieldStyles> copyWith({
    TextStyle? textStyle,
    MColor? textColor,
    MColor? fillColor,
    MColor? fillColorDisabled,
    MColor? errorColor,
    BoxBorder? border,
    BoxBorder? borderFocused,
    BoxBorder? borderError,
  }) {
    return MOtpFieldStyles(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? textColor,
      fillColor: fillColor ?? fillColor,
      fillColorDisabled: fillColorDisabled ?? fillColorDisabled,
      errorColor: errorColor ?? errorColor,
      border: border ?? border,
      borderFocused: borderFocused ?? borderFocused,
      borderError: borderError ?? borderError,
    );
  }

  @override
  ThemeExtension<MOtpFieldStyles> lerp(MOtpFieldStyles? other, double t) {
    return MOtpFieldStyles(
      textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
      textColor: MColor.lerp(textColor, other?.textColor, t),
      fillColor: MColor.lerp(fillColor, other?.fillColor, t),
      fillColorDisabled:
          MColor.lerp(fillColorDisabled, other?.fillColorDisabled, t),
      errorColor: MColor.lerp(errorColor, other?.errorColor, t),
      border: BoxBorder.lerp(border, other?.border, t),
      borderFocused: BoxBorder.lerp(borderFocused, other?.borderFocused, t),
      borderError: BoxBorder.lerp(borderError, other?.borderError, t),
    );
  }
}
