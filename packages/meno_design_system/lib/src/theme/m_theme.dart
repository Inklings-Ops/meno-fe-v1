import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_dimensions.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:meno_design_system/src/theme/styles/m_card_styles.dart';

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
      cardStyles: MCardStyles.$default(colorScheme: colorScheme),
    );
  }

  static ThemeData raw({
    required Brightness brightness,
    required MButtonStyle buttonStyles,
    required MColorScheme colorScheme,
    required MAppBarStyles appBarStyle,
    required MCardStyles cardStyles,
  }) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      cardTheme: CardTheme(
        color: cardStyles.backgroundColor,
      ),
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
        color: MInternal.resolve(isLight, MColor.grey30, MColor.grey400),
        thickness: 1,
      ),
      dividerColor: MInternal.resolve(isLight, MColor.grey30, MColor.grey400),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor:
            MInternal.resolve(isLight, MColor.white, MColor.primary700),
        unselectedItemColor:
            MInternal.resolve(isLight, MColor.grey70, MColor.grey50),
        selectedItemColor:
            MInternal.resolve(isLight, MColor.primary300, MColor.primary75),
        unselectedIconTheme: IconThemeData(
          color: MInternal.resolve(isLight, MColor.grey70, MColor.grey50),
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color:
              MInternal.resolve(isLight, MColor.primary300, MColor.primary75),
          size: 20,
        ),
        unselectedLabelStyle: MTextStyle.microMedium.copyWith(
          height: 1,
          color: MInternal.resolve(isLight, MColor.grey70, MColor.grey50),
        ),
        selectedLabelStyle: MTextStyle.microMedium.copyWith(
          height: 1,
          color:
              MInternal.resolve(isLight, MColor.primary300, MColor.primary75),
        ),
      ),
      scaffoldBackgroundColor:
          MInternal.resolve(isLight, MColor.white, MColor.primary700),
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
        cardStyles,
        MTextFieldStyle.$default(brightness: brightness),
      ],
    );
  }
}
