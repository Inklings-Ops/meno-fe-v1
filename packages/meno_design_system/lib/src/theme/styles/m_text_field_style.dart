import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTextFieldStyle extends ThemeExtension<MTextFieldStyle> {
  final MTextStyle? textStyle;
  final MTextStyle? errorTextStyle;
  final MTextStyle? hintTextStyle;
  final MTextStyle? labelTextStyle;
  final MTextStyle? counterTextStyle;
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
    this.borderDisabled,
    this.borderError,
  });

  factory MTextFieldStyle.$default({required Brightness brightness}) {
    final isLight = brightness == Brightness.light;
    final defaultColor = resolve(isLight, MColor.black, MColor.white);

    return MTextFieldStyle(
      textStyle: MTextStyle.captionRegular,
      errorTextStyle: MTextStyle.captionRegular,
      hintTextStyle: MTextStyle.captionRegular,
      labelTextStyle: MTextStyle.captionMedium,
      counterTextStyle: MTextStyle.microMedium,
      iconColor: defaultColor,
      fillColor: resolve(isLight, MColor.white, MColor.primary700),
      fillColorDisabled: resolve(isLight, MColor.grey30, MColor.primary600),
      counterBgColor: resolve(isLight, MColor.primary50, MColor.counter),
      counterTextColor: resolve(isLight, MColor.primary300, MColor.primary60),
      counterBgColorDisabled:
          resolve(isLight, MColor.grey30, MColor.primary600),
      counterTextColorDisabled: resolve(isLight, MColor.grey500, MColor.grey50),
      textColor: resolve(isLight, MColor.black, MColor.white),
      errorColor: resolve(isLight, MColor.error300, MColor.error75),
      border: const OutlineInputBorder(
        borderRadius: MDimensions.mediumBorderRadius,
        borderSide: BorderSide(color: MColor.grey50, width: 1.0),
      ),
      borderDisabled: const OutlineInputBorder(
        borderRadius: MDimensions.mediumBorderRadius,
        borderSide: BorderSide.none,
      ),
      borderError: OutlineInputBorder(
        borderRadius: MDimensions.mediumBorderRadius,
        borderSide: BorderSide(
          color: resolve(isLight, MColor.error300, MColor.error75),
          width: 2.0,
        ),
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
    MTextStyle? textStyle,
    MTextStyle? errorTextStyle,
    MTextStyle? hintTextStyle,
    MTextStyle? labelTextStyle,
    MTextStyle? counterTextStyle,
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
      borderDisabled: borderDisabled ?? this.borderDisabled,
      borderError: borderError ?? this.borderError,
    );
  }

  @override
  ThemeExtension<MTextFieldStyle> lerp(MTextFieldStyle? other, double t) {
    return MTextFieldStyle(
      textStyle: MTextStyle.lerp(textStyle, other?.textStyle, t),
      errorTextStyle: MTextStyle.lerp(errorTextStyle, other?.errorTextStyle, t),
      hintTextStyle: MTextStyle.lerp(hintTextStyle, other?.hintTextStyle, t),
      labelTextStyle: MTextStyle.lerp(labelTextStyle, other?.labelTextStyle, t),
      counterTextStyle:
          MTextStyle.lerp(counterTextStyle, other?.counterTextStyle, t),
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
      borderDisabled: borderDisabled,
      borderError: borderError,
    );
  }
}
