import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/fonts.gen.dart';

class MTheme {
  static ThemeData theme(Brightness brightness) => createTheme(brightness);

  static ThemeData get dark => createTheme(Brightness.dark);

  static ThemeData get light => createTheme(Brightness.light);

  MTheme._();

  static ThemeData createTheme(Brightness brightness) {
    return raw(MColorScheme.$default(brightness));
  }

  static ThemeData raw(MColorScheme colors) {
    final textTheme = MTextTheme.$default();
    final buttonStyles = MButtonStyles.$default(colors);
    final globalStyles = MGlobalStyles.$default(colors);
    final navStyles = MNavigationStyles.$default(colors);
    final modalStyles = MModalStyles.$default(colors);
    final cardStyles = MCardStyles.$default(colors);
    final textInputStyles = MTextFieldStyle.$default(colors);

    return ThemeData(
      cardTheme: cardStyles.cardTheme,
      colorScheme: colors.getColorScheme,
      elevatedButtonTheme: buttonStyles.elevatedButtonTheme,
      outlinedButtonTheme: buttonStyles.outlinedButtonTheme,
      textButtonTheme: buttonStyles.textButtonTheme,
      dividerTheme: globalStyles.dividerTheme,
      dividerColor: globalStyles.dividerColor,
      scaffoldBackgroundColor: colors.background,
      bottomNavigationBarTheme: navStyles.bottomNavigationBarTheme,
      appBarTheme: navStyles.appBarTheme,
      tabBarTheme: navStyles.tabBarTheme,
      iconTheme: IconThemeData(
        color: colors.onBackground,
        size: 24.toScale,
      ),
      fontFamily: FontFamily.sFProDisplay,
      disabledColor: colors.disabled,
      useMaterial3: true,
      snackBarTheme: globalStyles.snackBarTheme,
      checkboxTheme: globalStyles.checkboxTheme,
      bottomSheetTheme: modalStyles.bottomSheetTheme,
      listTileTheme: ListTileThemeData(textColor: colors.onBackground),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearMinHeight: 4.toScale,
        linearTrackColor: colors.background,
        circularTrackColor: colors.background,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: textInputStyles.border,
        focusedBorder: textInputStyles.borderFocused,
        enabledBorder: textInputStyles.border,
        errorBorder: textInputStyles.borderError,
        disabledBorder: textInputStyles.borderDisabled,
        filled: true,
        iconColor: textInputStyles.iconColor,
        hintStyle: textInputStyles.hintTextStyle,
        labelStyle: textInputStyles.labelTextStyle,
        errorStyle: textInputStyles.errorTextStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: $styles.insets.medium),
      ),
      textTheme: textTheme.globalTextTheme,
      chipTheme: ChipThemeData(
        showCheckmark: false,
        padding: EdgeInsets.symmetric(
          horizontal: $styles.insets.large,
          vertical: 6.toScale,
        ),
        labelPadding: EdgeInsets.zero,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.circle),
        labelStyle: $styles.text.captionMedium,
        color: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return colors.primary;
            } else {
              return colors.inActiveContainer;
            }
          },
        ),
      ),
      extensions: [
        buttonStyles,
        globalStyles,
        colors,
        cardStyles,
        navStyles,
        modalStyles,
        textInputStyles,
        textTheme,
        MOtpFieldStyles.$default(colors),
      ],
    );
  }
}
