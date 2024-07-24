import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTextFieldStyle extends ThemeExtension<MTextFieldStyle> {
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? counterTextStyle;
  final MColor? textColor;
  final MColor? iconColor;
  final MColor? fillColor;
  final MColor? fillColorDisabled;
  final MColor? counterBgColor;
  final MColor? counterTextColor;
  final MColor? counterBgColorDisabled;
  final MColor? counterTextColorDisabled;
  final MColor? errorColor;
  final InputBorder? border;
  final InputBorder? borderFocused;
  final InputBorder? borderDisabled;
  final InputBorder? borderError;

  MTextFieldStyle({
    this.textStyle,
    this.errorTextStyle,
    this.hintTextStyle,
    this.labelTextStyle,
    this.counterTextStyle,
    this.textColor,
    this.iconColor,
    this.fillColor,
    this.fillColorDisabled,
    this.counterBgColor,
    this.counterTextColor,
    this.counterBgColorDisabled,
    this.counterTextColorDisabled,
    this.errorColor,
    this.border,
    this.borderFocused,
    this.borderDisabled,
    this.borderError,
  });

  factory MTextFieldStyle.$default(MColorScheme colors) {
    final isLight = colors.brightness == Brightness.light;

    return MTextFieldStyle(
      textStyle: $styles.text.captionRegular,
      errorTextStyle: $styles.text.captionRegular,
      hintTextStyle: $styles.text.captionRegular,
      labelTextStyle: $styles.text.captionMedium,
      counterTextStyle: $styles.text.microMedium,
      iconColor: colors.onBackground,
      fillColor: colors.background,
      fillColorDisabled: colors.disabledContainer,
      counterBgColor: resolve(isLight, MColor.primary50, MColor.counter),
      counterTextColor: resolve(isLight, MColor.primary300, MColor.primary60),
      counterBgColorDisabled: colors.disabledContainer,
      counterTextColorDisabled: colors.disabled,
      textColor: colors.onBackground,
      errorColor: colors.error,
      border: OutlineInputBorder(
        borderRadius: $styles.radius.medium,
        borderSide: BorderSide(color: MColor.grey50, width: 1.toScale),
      ),
      borderFocused: OutlineInputBorder(
        borderRadius: $styles.radius.medium,
        borderSide: BorderSide(color: colors.primary!, width: 2.toScale),
      ),
      borderDisabled: OutlineInputBorder(
        borderRadius: $styles.radius.medium,
        borderSide: BorderSide.none,
      ),
      borderError: OutlineInputBorder(
        borderRadius: $styles.radius.medium,
        borderSide: BorderSide(color: colors.error!, width: 2.toScale),
      ),
    );
  }

  static MTextFieldStyle? of(BuildContext context) {
    return Theme.of(context).extension<MTextFieldStyle>();
  }

  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  @override
  ThemeExtension<MTextFieldStyle> copyWith({
    TextStyle? textStyle,
    TextStyle? errorTextStyle,
    TextStyle? hintTextStyle,
    TextStyle? labelTextStyle,
    TextStyle? counterTextStyle,
    MColor? textColor,
    MColor? iconColor,
    MColor? fillColor,
    MColor? fillColorDisabled,
    MColor? counterBgColor,
    MColor? counterTextColor,
    MColor? counterBgColorDisabled,
    MColor? counterTextColorDisabled,
    MColor? errorColor,
    InputBorder? border,
    InputBorder? borderFocused,
    InputBorder? borderDisabled,
    InputBorder? borderError,
  }) {
    return MTextFieldStyle(
      textStyle: textStyle ?? this.textStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      counterTextStyle: counterTextStyle ?? this.counterTextStyle,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      fillColor: fillColor ?? this.fillColor,
      fillColorDisabled: fillColorDisabled ?? this.fillColorDisabled,
      counterBgColor: counterBgColor ?? this.counterBgColor,
      counterTextColor: counterTextColor ?? this.counterTextColor,
      counterBgColorDisabled:
          counterBgColorDisabled ?? this.counterBgColorDisabled,
      counterTextColorDisabled:
          counterTextColorDisabled ?? this.counterTextColorDisabled,
      errorColor: errorColor ?? this.errorColor,
      border: border ?? this.border,
      borderFocused: borderFocused ?? this.borderFocused,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      borderError: borderError ?? this.borderError,
    );
  }

  @override
  ThemeExtension<MTextFieldStyle> lerp(MTextFieldStyle? other, double t) {
    return MTextFieldStyle(
      textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
      errorTextStyle: TextStyle.lerp(errorTextStyle, other?.errorTextStyle, t),
      hintTextStyle: TextStyle.lerp(hintTextStyle, other?.hintTextStyle, t),
      labelTextStyle: TextStyle.lerp(labelTextStyle, other?.labelTextStyle, t),
      counterTextStyle:
          TextStyle.lerp(counterTextStyle, other?.counterTextStyle, t),
      textColor: MColor.lerp(textColor, other?.textColor, t),
      iconColor: MColor.lerp(iconColor, other?.iconColor, t),
      fillColor: MColor.lerp(fillColor, other?.fillColor, t),
      fillColorDisabled:
          MColor.lerp(fillColorDisabled, other?.fillColorDisabled, t),
      counterBgColor: MColor.lerp(counterBgColor, other?.counterBgColor, t),
      counterTextColor:
          MColor.lerp(counterTextColor, other?.counterTextColor, t),
      counterBgColorDisabled:
          MColor.lerp(counterBgColorDisabled, other?.counterBgColorDisabled, t),
      counterTextColorDisabled: MColor.lerp(
          counterTextColorDisabled, other?.counterTextColorDisabled, t),
      errorColor: MColor.lerp(errorColor, other?.errorColor, t),
      border: border,
      borderFocused: borderFocused,
      borderDisabled: borderDisabled,
      borderError: borderError,
    );
  }
}
