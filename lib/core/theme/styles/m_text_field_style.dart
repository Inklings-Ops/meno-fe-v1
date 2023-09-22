import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/theme/m_color.dart';
import 'package:meno_fe_v1/core/theme/styles/m_text_style.dart';

class MTextFieldStyle extends ThemeExtension<MTextFieldStyle> {
  final TextStyle? textStyle;
  final TextStyle? textStyleDisabled;
  final TextStyle? textStyleError;

  final TextStyle? hintTextStyle;
  final TextStyle? hintTextStyleDisabled;

  final TextStyle? labelTextStyle;
  final TextStyle? labelTextStyleError;

  final TextStyle? counterTextStyle;

  final Color? iconColor;
  final Color? iconColorError;
  final Color? fillColor;
  final Color? fillColorDisabled;
  final Color? counterBgColor;
  final Color? counterTextColor;
  final Color? counterBgColorDisabled;
  final Color? counterTextColorDisabled;

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
    this.iconColor,
    this.iconColorError,
    this.fillColor,
    this.fillColorDisabled,
    this.counterBgColor,
    this.counterTextColor,
    this.counterBgColorDisabled,
    this.counterTextColorDisabled,
    this.border,
    this.borderFocused,
    this.borderError,
  });

  factory MTextFieldStyle.$default({required Brightness brightness}) {
    final isLight = brightness == Brightness.light;
    final defaultColor = resolve(isLight, MColor.black, MColor.white);
    final errorColor = resolve(isLight, MColor.error300, MColor.error75);
    return MTextFieldStyle(
      textStyle: MTextStyle.captionRegular.copyWith(height: 18 / 14),
      hintTextStyle: MTextStyle.captionRegular.copyWith(height: 18 / 14),
      labelTextStyle: MTextStyle.captionMedium,
      labelTextStyleError: MTextStyle.captionMedium.copyWith(color: errorColor),
      counterTextStyle: MTextStyle.microMedium.copyWith(height: 16 / 12),
      iconColor: defaultColor,
      fillColor: resolve(isLight, MColor.white, MColor.primary700),
      fillColorDisabled: resolve(isLight, MColor.grey30, MColor.primary600),
      counterBgColor:
          resolve(isLight, MColor.primary50, const Color(0xFF2A213C)),
      counterTextColor: resolve(isLight, MColor.primary300, MColor.primary60),
      counterBgColorDisabled:
          resolve(isLight, MColor.grey30, MColor.primary600),
      counterTextColorDisabled: resolve(isLight, MColor.grey500, MColor.grey50),
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
    TextStyle? textStyle,
    TextStyle? textStyleDisabled,
    TextStyle? textStyleError,
    TextStyle? hintTextStyle,
    TextStyle? hintTextStyleDisabled,
    TextStyle? labelTextStyle,
    TextStyle? labelTextStyleDisabled,
    TextStyle? labelTextStyleError,
    TextStyle? counterTextStyle,
    Color? iconColor,
    Color? iconColorError,
    Color? fillColor,
    Color? fillColorDisabled,
    Color? counterBgColor,
    Color? counterTextColor,
    Color? counterBgColorDisabled,
    Color? counterTextColorDisabled,
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
      border: border ?? this.border,
      borderFocused: borderFocused ?? this.borderFocused,
      borderError: borderError ?? this.borderError,
    );
  }

  @override
  ThemeExtension<MTextFieldStyle> lerp(MTextFieldStyle? other, double t) {
    return MTextFieldStyle(
      textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
      textStyleDisabled:
          TextStyle.lerp(textStyleDisabled, other?.textStyleDisabled, t),
      textStyleError: TextStyle.lerp(textStyleError, other?.textStyleError, t),
      hintTextStyle: TextStyle.lerp(hintTextStyle, other?.hintTextStyle, t),
      hintTextStyleDisabled: TextStyle.lerp(
          hintTextStyleDisabled, other?.hintTextStyleDisabled, t),
      labelTextStyle: TextStyle.lerp(labelTextStyle, other?.labelTextStyle, t),
      labelTextStyleError:
          TextStyle.lerp(labelTextStyleError, other?.labelTextStyleError, t),
      counterTextStyle:
          TextStyle.lerp(counterTextStyle, other?.counterTextStyle, t),
      iconColor: Color.lerp(iconColor, other?.iconColor, t),
      iconColorError: Color.lerp(iconColorError, other?.iconColorError, t),
      fillColor: Color.lerp(fillColor, other?.fillColor, t),
      fillColorDisabled:
          Color.lerp(fillColorDisabled, other?.fillColorDisabled, t),
      counterBgColor: Color.lerp(counterBgColor, other?.counterBgColor, t),
      counterTextColor:
          Color.lerp(counterTextColor, other?.counterTextColor, t),
      counterBgColorDisabled:
          Color.lerp(counterBgColorDisabled, other?.counterBgColorDisabled, t),
      counterTextColorDisabled: Color.lerp(
          counterTextColorDisabled, other?.counterTextColorDisabled, t),
      border: BoxBorder.lerp(border, other?.border, t),
      borderFocused: BoxBorder.lerp(borderFocused, other?.borderFocused, t),
      borderError: BoxBorder.lerp(borderError, other?.borderError, t),
    );
  }
}
