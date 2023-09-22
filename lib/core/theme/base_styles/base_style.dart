// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/theme/m_color_scheme.dart';

class BaseStyle extends ThemeExtension<BaseStyle> {
  final Brightness? brightness;
  final MColorScheme? colorScheme;

  BaseStyle({
    this.brightness,
    this.colorScheme,
  });

  factory BaseStyle.$default({required Brightness brightness}) {
    return BaseStyle(
      brightness: brightness,
      colorScheme: MColorScheme.$default(brightness),
    );
  }

  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  static BaseStyle of(context) => Theme.of(context).extension<BaseStyle>()!;

  @override
  ThemeExtension<BaseStyle> copyWith({
    Brightness? brightness,
    MColorScheme? colorScheme,
  }) {
    return BaseStyle(
      brightness: brightness ?? this.brightness,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  ThemeExtension<BaseStyle> lerp(ThemeExtension<BaseStyle>? other, double t) {
    if (other is! BaseStyle) return this;
    return BaseStyle(
      brightness: other.brightness,
      colorScheme: other.colorScheme,
    );
  }
}
