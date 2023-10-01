import 'package:flutter/material.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:meno_design_system/src/theme/m_color.dart';
import 'package:meno_design_system/src/theme/styles/base_button_style.dart';

class MButtonStyle extends ThemeExtension<MButtonStyle> {
  final BaseButtonStyle? primary;
  final BaseButtonStyle? secondary;
  final BaseButtonStyle? text;
  final BaseButtonStyle? success;
  final BaseButtonStyle? danger;

  MButtonStyle({
    this.primary,
    this.secondary,
    this.text,
    this.success,
    this.danger,
  });

  factory MButtonStyle.$default({required Brightness brightness}) {
    final isLight = brightness == Brightness.light;
    final disabledBackground = resolve(isLight, MColor.grey50, MColor.grey900);

    return MButtonStyle(
      primary: BaseButtonStyle(
        background: resolve(isLight, MColor.primary300, MColor.primary75),
        backgroundDisabled: disabledBackground,
        backgroundPressed: resolve(
          isLight,
          MColor.primary75,
          MColor.primary200,
        ),
        foreground: resolve(isLight, MColor.white, MColor.primary700),
        foregroundDisabled: resolve(isLight, MColor.grey900, MColor.white),
        foregroundPressed: resolve(isLight, MColor.primary600, MColor.grey10),
        iconColor: resolve(isLight, MColor.white, MColor.primary700),
        iconColorDisabled: resolve(isLight, MColor.primary600, MColor.white),
        iconColorPressed: resolve(isLight, MColor.primary75, MColor.grey10),
      ),
      secondary: BaseButtonStyle(
        background: MColor.transparent,
        backgroundPressed: resolve(
          isLight,
          MColor.primary75,
          MColor.primary200,
        ),
        backgroundDisabled: disabledBackground,
        foreground: resolve(isLight, MColor.primary300, MColor.primary75),
        foregroundPressed: resolve(
          isLight,
          MColor.primary300,
          MColor.primary75,
        ),
        foregroundDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
        iconColor: resolve(isLight, MColor.primary300, MColor.primary75),
        iconColorPressed: resolve(isLight, MColor.primary300, MColor.primary75),
        iconColorDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
        borderColor: resolve(isLight, MColor.primary300, MColor.primary75),
        borderColorPressed: resolve(
          isLight,
          MColor.primary300,
          MColor.primary75,
        ),
        borderColorDisabled: MColor.transparent,
      ),
      text: BaseButtonStyle(
        background: MColor.transparent,
        backgroundPressed: MColor.transparent,
        backgroundDisabled: disabledBackground,
        foreground: resolve(isLight, MColor.primary300, MColor.primary75),
        foregroundPressed: resolve(
          isLight,
          MColor.primary75,
          MColor.primary200,
        ),
        foregroundDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
        iconColor: resolve(isLight, MColor.primary300, MColor.primary75),
        iconColorPressed: resolve(isLight, MColor.primary75, MColor.primary200),
        iconColorDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
      ),
      success: BaseButtonStyle(
        background: resolve(isLight, MColor.success300, MColor.success75),
        backgroundPressed: resolve(
          isLight,
          MColor.success75,
          MColor.success300,
        ),
        backgroundDisabled: resolve(
          isLight,
          MColor.primary75,
          MColor.primary200,
        ),
        foreground: resolve(isLight, MColor.white, MColor.success600),
        foregroundPressed: resolve(isLight, MColor.success600, MColor.white),
        foregroundDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
        iconColor: resolve(isLight, MColor.white, MColor.success600),
        iconColorPressed: resolve(isLight, MColor.success600, MColor.white),
        iconColorDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
      ),
      danger: BaseButtonStyle(
        background: resolve(isLight, MColor.error300, MColor.error75),
        backgroundPressed: resolve(isLight, MColor.error75, MColor.error300),
        backgroundDisabled: resolve(
          isLight,
          MColor.primary75,
          MColor.primary200,
        ),
        foreground: resolve(isLight, MColor.white, MColor.error600),
        foregroundPressed: resolve(isLight, MColor.error600, MColor.white),
        foregroundDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
        iconColor: resolve(isLight, MColor.white, MColor.error600),
        iconColorPressed: resolve(isLight, MColor.error600, MColor.white),
        iconColorDisabled: resolve(isLight, MColor.grey900, MColor.grey10),
      ),
    );
  }

  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  static MButtonStyle? of(BuildContext context) {
    return Theme.of(context).extension<MButtonStyle>();
  }

  static ButtonStyle get baseButtonStyle {
    return ButtonStyle(
      overlayColor: MInternal.all(MColor.transparent),
      shape: MInternal.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      iconSize: MInternal.resolveWith(defaultValue: 14),
      fixedSize: MInternal.all(const Size.fromHeight(48.0)),
      padding: MInternal.all(const EdgeInsets.fromLTRB(16, 8, 16, 8)),
      elevation: MInternal.all(0),
      shadowColor: MInternal.all(MColor.shadow),
    );
  }

  ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(style: primary?.override(baseButtonStyle));
  }

  OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(style: secondary?.override(baseButtonStyle));
  }

  TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(style: text?.override(baseButtonStyle));
  }

  FilledButtonThemeData get filledButtonTheme {
    return FilledButtonThemeData(style: success?.override(baseButtonStyle));
  }

  @override
  ThemeExtension<MButtonStyle> copyWith({
    BaseButtonStyle? primary,
    BaseButtonStyle? secondary,
    BaseButtonStyle? text,
    BaseButtonStyle? success,
    BaseButtonStyle? danger,
  }) {
    return MButtonStyle(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      text: text ?? this.text,
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<MButtonStyle> lerp(
    ThemeExtension<MButtonStyle>? other,
    double t,
  ) {
    if (other is! MButtonStyle) return this;
    return MButtonStyle(
      primary: primary?.lerp(other.primary, t),
      secondary: secondary?.lerp(other.secondary, t),
      text: text?.lerp(other.text, t),
      success: success?.lerp(other.success, t),
      danger: danger?.lerp(other.danger, t),
    );
  }
}

extension MButtonStyleX on MButtonStyle? {
  MButtonStyle merge(MButtonStyle? other) {
    if (this == null) return other ?? MButtonStyle();
    return this?.copyWith(
      primary: this?.primary.merge(other?.primary),
      secondary: this?.secondary.merge(other?.secondary),
      text: this?.text.merge(other?.text),
      success: this?.success.merge(other?.success),
      danger: this?.danger.merge(other?.danger),
    ) as MButtonStyle;
  }
}
