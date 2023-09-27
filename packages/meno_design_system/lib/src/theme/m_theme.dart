import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_dimensions.dart';
import 'package:meno_design_system/src/theme/m_color_scheme.dart';
import 'package:meno_design_system/src/theme/styles/m_app_bar_styles.dart';
import 'package:meno_design_system/src/theme/styles/m_button_style.dart';
import 'package:meno_design_system/src/theme/styles/m_text_field_style.dart';
import 'package:meno_design_system/src/theme/styles/m_text_style.dart';

import 'm_color.dart';

class MTheme {
  static ThemeData get dark => createTheme(brightness: Brightness.dark);

  static ThemeData get light => createTheme(brightness: Brightness.light);

  MTheme._();

  static ThemeData createTheme({required Brightness brightness}) {
    final buttonStyles = MButtonStyle.$default(brightness: brightness);
    final colorScheme = MColorScheme.$default(brightness);
    final appBarStyle = MAppBarStyles.$default(colorScheme: colorScheme);
    return raw(
      brightness: brightness,
      buttonStyles: buttonStyles,
      colorScheme: colorScheme,
      appBarStyle: appBarStyle,
    );
  }

  static ThemeData raw({
    required Brightness brightness,
    required MButtonStyle buttonStyles,
    required MColorScheme colorScheme,
    required MAppBarStyles appBarStyle,
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: resolve(isLight, MColor.white, MColor.primary700),
        unselectedItemColor: resolve(isLight, MColor.grey70, MColor.grey50),
        selectedItemColor:
            resolve(isLight, MColor.primary300, MColor.primary75),
        unselectedIconTheme: IconThemeData(
          color: resolve(isLight, MColor.grey70, MColor.grey50),
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: resolve(isLight, MColor.primary300, MColor.primary75),
          size: 20,
        ),
        unselectedLabelStyle: MTextStyle.microMedium.copyWith(
          height: 1,
          color: resolve(isLight, MColor.grey70, MColor.grey50),
        ),
        selectedLabelStyle: MTextStyle.microMedium.copyWith(
          height: 1,
          color: resolve(isLight, MColor.primary300, MColor.primary75),
        ),
      ),
      scaffoldBackgroundColor:
          resolve(isLight, MColor.white, MColor.primary700),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: colorScheme.background,
        titleSpacing: 0,
        titleTextStyle: MTextStyle.bodyMedium.copyWith(
          color: colorScheme.onBackground,
        ),
        actionsIconTheme: appBarStyle.iconTheme,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: MDimensions.micro,
      ),
      elevatedButtonTheme: buttonStyles.elevatedButtonTheme,
      outlinedButtonTheme: buttonStyles.outlinedButtonTheme,
      textButtonTheme: buttonStyles.textButtonTheme,
      filledButtonTheme: buttonStyles.filledButtonTheme,
      fontFamily: FontFamily.sFProDisplay,
      disabledColor: MColor.grey50,
      useMaterial3: true,
      extensions: [
        buttonStyles,
        colorScheme,
        appBarStyle,
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
