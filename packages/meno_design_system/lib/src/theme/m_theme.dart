import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTheme {
  static ThemeData get dark => createTheme(brightness: Brightness.dark);

  static ThemeData get light => createTheme(brightness: Brightness.light);

  MTheme._();

  static ThemeData createTheme({required Brightness brightness}) {
    return raw(colorScheme: MColorScheme.$default(brightness));
  }

  static ThemeData raw({
    required MColorScheme colorScheme,
  }) {
    final buttonStyles = MButtonStyles.$default(colorScheme: colorScheme);
    final globalStyles = MGlobalStyles.$default(colorScheme: colorScheme);
    final navStyles = MNavigationStyles.$default(colorScheme: colorScheme);
    final modalStyles = MModalStyles.$default(colorScheme: colorScheme);
    final cardStyles = MCardStyles.$default(colorScheme: colorScheme);

    return ThemeData(
      cardTheme: cardStyles.cardTheme,
      colorScheme: colorScheme.getColorScheme,
      elevatedButtonTheme: buttonStyles.elevatedButtonTheme,
      outlinedButtonTheme: buttonStyles.outlinedButtonTheme,
      textButtonTheme: buttonStyles.textButtonTheme,
      dividerTheme: globalStyles.dividerTheme,
      dividerColor: globalStyles.dividerColor,
      scaffoldBackgroundColor: colorScheme.background,
      bottomNavigationBarTheme: navStyles.bottomNavigationBarTheme,
      appBarTheme: navStyles.appBarTheme,
      tabBarTheme: navStyles.tabBarTheme,
      iconTheme: IconThemeData(color: colorScheme.onBackground, size: 24.0),
      fontFamily: FontFamily.sFProDisplay,
      disabledColor: colorScheme.disabled,
      useMaterial3: true,
      snackBarTheme: globalStyles.snackBarTheme,
      checkboxTheme: globalStyles.checkboxTheme,
      bottomSheetTheme: modalStyles.bottomSheetTheme,
      extensions: [
        buttonStyles,
        globalStyles,
        colorScheme,
        cardStyles,
        navStyles,
        modalStyles,
        MOtpFieldStyles.$default(colorScheme: colorScheme),
        MTextFieldStyle.$default(colorScheme: colorScheme),
      ],
    );
  }
}
