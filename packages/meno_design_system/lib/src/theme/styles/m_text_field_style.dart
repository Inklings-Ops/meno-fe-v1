import 'package:flutter/material.dart';
import 'package:meno_design_system/src/theme/m_color.dart';
import 'package:meno_design_system/src/theme/styles/m_text_style.dart';

class MTextFieldStyle extends ThemeExtension<MTextFieldStyle> {
  final MTextStyle? textStyle;
  final MTextStyle? textStyleDisabled;
  final MTextStyle? textStyleError;

  final MTextStyle? hintTextStyle;
  final MTextStyle? hintTextStyleDisabled;

  final MTextStyle? labelTextStyle;
  final MTextStyle? labelTextStyleError;

  final MTextStyle? counterTextStyle;

  final MColor? textColor;
  final MColor? iconColor;
  final MColor? iconColorError;
  final MColor? fillColor;
  final MColor? fillColorDisabled;
  final MColor? counterBgColor;
  final MColor? counterTextColor;
  final MColor? counterBgColorDisabled;
  final MColor? counterTextColorDisabled;
  final MColor? errorColor;

  final BoxBorder? border;
  final BoxBorder? borderFocused;
  final BoxBorder? borderError;

  MTextFieldStyle({
    this.textStyle,
    this.textStyleDisabled,
    this.textStyleError,
    this.hintTextStyle,
    this.hintTextStyleDisabled,
    this.labelTextStyle,
    this.labelTextStyleError,
    this.counterTextStyle,
    this.textColor,
    this.iconColor,
    this.iconColorError,
    this.fillColor,
    this.fillColorDisabled,
    this.counterBgColor,
    this.counterTextColor,
    this.counterBgColorDisabled,
    this.counterTextColorDisabled,
    this.errorColor,
    this.border,
    this.borderFocused,
    this.borderError,
  });

  factory MTextFieldStyle.$default({required Brightness brightness}) {
    final isLight = brightness == Brightness.light;
    final defaultColor = resolve(isLight, MColor.black, MColor.white);

    return MTextFieldStyle(
      textStyle: MTextStyle.captionRegular,
      hintTextStyle: MTextStyle.captionRegular,
      labelTextStyle: MTextStyle.captionMedium,
      labelTextStyleError: MTextStyle.captionMedium,
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
      border: Border.all(color: MColor.grey50, width: 1),
      borderFocused: Border.all(
        color: resolve(isLight, MColor.primary300, MColor.primary75),
        width: 2,
      ),
      borderError: Border.all(
        color: resolve(isLight, MColor.error300, MColor.error75),
        width: 2,
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
    MTextStyle? textStyleDisabled,
    MTextStyle? textStyleError,
    MTextStyle? hintTextStyle,
    MTextStyle? hintTextStyleDisabled,
    MTextStyle? labelTextStyle,
    MTextStyle? labelTextStyleDisabled,
    MTextStyle? labelTextStyleError,
    MTextStyle? counterTextStyle,
    MColor? textColor,
    MColor? iconColor,
    MColor? iconColorError,
    MColor? fillColor,
    MColor? fillColorDisabled,
    MColor? counterBgColor,
    MColor? counterTextColor,
    MColor? counterBgColorDisabled,
    MColor? counterTextColorDisabled,
    MColor? errorColor,
    BoxBorder? border,
    BoxBorder? borderFocused,
    BoxBorder? borderError,
  }) {
    return MTextFieldStyle(
      textStyle: textStyle ?? this.textStyle,
      textStyleDisabled: textStyleDisabled ?? this.textStyleDisabled,
      textStyleError: textStyleError ?? this.textStyleError,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      hintTextStyleDisabled:
          hintTextStyleDisabled ?? this.hintTextStyleDisabled,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      labelTextStyleError: labelTextStyleError ?? this.labelTextStyleError,
      counterTextStyle: counterTextStyle ?? this.counterTextStyle,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      iconColorError: iconColorError ?? this.iconColorError,
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
      borderError: borderError ?? this.borderError,
    );
  }

  @override
  ThemeExtension<MTextFieldStyle> lerp(MTextFieldStyle? other, double t) {
    return MTextFieldStyle(
      textStyle: MTextStyle.lerp(textStyle, other?.textStyle, t),
      textStyleDisabled:
          MTextStyle.lerp(textStyleDisabled, other?.textStyleDisabled, t),
      textStyleError: MTextStyle.lerp(textStyleError, other?.textStyleError, t),
      hintTextStyle: MTextStyle.lerp(hintTextStyle, other?.hintTextStyle, t),
      hintTextStyleDisabled: MTextStyle.lerp(
          hintTextStyleDisabled, other?.hintTextStyleDisabled, t),
      labelTextStyle: MTextStyle.lerp(labelTextStyle, other?.labelTextStyle, t),
      labelTextStyleError:
          MTextStyle.lerp(labelTextStyleError, other?.labelTextStyleError, t),
      counterTextStyle:
          MTextStyle.lerp(counterTextStyle, other?.counterTextStyle, t),
      textColor: MColor.lerp(textColor, other?.textColor, t),
      iconColor: MColor.lerp(iconColor, other?.iconColor, t),
      iconColorError: MColor.lerp(iconColorError, other?.iconColorError, t),
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
      border: BoxBorder.lerp(border, other?.border, t),
      borderFocused: BoxBorder.lerp(borderFocused, other?.borderFocused, t),
      borderError: BoxBorder.lerp(borderError, other?.borderError, t),
    );
  }
}
