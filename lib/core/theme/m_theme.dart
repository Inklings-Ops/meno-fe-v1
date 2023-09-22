import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/gen/fonts.gen.dart';
import 'package:meno_fe_v1/core/theme/m_color_scheme.dart';
import 'package:meno_fe_v1/core/theme/styles/m_button_style.dart';
import 'package:meno_fe_v1/core/theme/styles/m_text_field_style.dart';
import 'package:meno_fe_v1/core/theme/styles/m_text_style.dart';

import 'm_color.dart';

class MTheme {
  static ThemeData get dark => createTheme(brightness: Brightness.dark);

  static ThemeData get light => createTheme(brightness: Brightness.light);

  MTheme._();

  static ThemeData createTheme({required Brightness brightness}) {
    return raw(
      brightness: brightness,
      buttonStyles: MButtonStyle.$default(brightness: brightness),
      colorScheme: MColorScheme.$default(brightness),
    );
  }

  static ThemeData raw({
    required Brightness brightness,
    required MButtonStyle buttonStyles,
    required MColorScheme colorScheme,
  }) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colorScheme.primary!,
        onPrimary: colorScheme.onPrimary!,
        onPrimaryContainer: colorScheme.onPrimaryContainer,
        primaryContainer: colorScheme.primaryContainer,
        secondary: colorScheme.secondary!,
        onSecondary: colorScheme.onSecondary!,
        secondaryContainer: colorScheme.secondaryContainer,
        onSecondaryContainer: colorScheme.onSecondaryContainer,
        tertiary: colorScheme.tertiary,
        onTertiary: colorScheme.onTertiary,
        tertiaryContainer: colorScheme.tertiaryContainer,
        onTertiaryContainer: colorScheme.onTertiaryContainer,
        error: colorScheme.error!,
        onError: colorScheme.onError!,
        errorContainer: colorScheme.errorContainer,
        onErrorContainer: colorScheme.onErrorContainer,
        background: colorScheme.background!,
        onBackground: colorScheme.onBackground!,
        surface: colorScheme.surface!,
        onSurface: colorScheme.onSurface!,
        surfaceTint: colorScheme.surfaceTint,
        inverseSurface: colorScheme.inverseSurface,
        onInverseSurface: colorScheme.onInverseSurface,
        inversePrimary: colorScheme.inversePrimary,
        outline: colorScheme.outline,
        outlineVariant: colorScheme.outlineVariant,
        scrim: colorScheme.scrim,
        shadow: colorScheme.shadow,
      ),
      dividerTheme: DividerThemeData(
        color: resolve(isLight, MColor.grey30, MColor.grey400),
        thickness: 1,
      ),
      dividerColor: resolve(isLight, MColor.grey30, MColor.grey400),
      elevatedButtonTheme: buttonStyles.elevatedButtonTheme,
      outlinedButtonTheme: buttonStyles.outlinedButtonTheme,
      textButtonTheme: buttonStyles.textButtonTheme,
      filledButtonTheme: buttonStyles.filledButtonTheme,
      fontFamily: FontFamily.sFProDisplay,
      disabledColor: MColor.grey50,
      extensions: [
        buttonStyles,
        colorScheme,
        MTextStyle.heading1Bold,
        MTextFieldStyle.$default(brightness: brightness),
      ],
    );
  }

  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  /// Convenience method for easier use of [MaterialStateProperty.all].
  static MaterialStateProperty<T> all<T>(T value) {
    return MaterialStateProperty.all(value);
  }

  /// Convenience method for easier use of [MaterialStateProperty.resolveWith].
  static MaterialStateProperty<T?> resolveWith<T>({
    required T defaultValue,
    T? pressedValue,
    T? disabledValue,
    T? hoveredValue,
    String? parent,
    T? selectedValue,
  }) {
    return MaterialStateProperty.resolveWith((states) {
      // disabled
      if (states.contains(MaterialState.disabled) && disabledValue != null) {
        return disabledValue;
      }

      // pressed / focused
      if (states.any({MaterialState.pressed, MaterialState.focused}.contains) &&
          pressedValue != null) {
        return pressedValue;
      }
      // hovered
      if (states.contains(MaterialState.hovered) && hoveredValue != null) {
        return hoveredValue;
      }

      // selected
      if (states.contains(MaterialState.selected) && selectedValue != null) {
        return selectedValue;
      }
      // default
      return defaultValue;
    });
  }
}
