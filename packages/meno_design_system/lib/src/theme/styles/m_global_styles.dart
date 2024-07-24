import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MGlobalStyles extends ThemeExtension<MGlobalStyles> {
  final MColor? dividerColor;
  final SnackBarThemeData? snackBarTheme;
  final CheckboxThemeData? checkboxTheme;

  MGlobalStyles({
    this.dividerColor,
    this.snackBarTheme,
    this.checkboxTheme,
  });

  factory MGlobalStyles.$default(MColorScheme colors) {
    return MGlobalStyles(
      dividerColor: colors.outlineVariant1,
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.micro),
        side: BorderSide(width: 1.toScale, color: colors.outlineVariant1!),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: $styles.text.captionRegular,
        insetPadding: EdgeInsets.all($styles.insets.large),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.medium),
      ),
    );
  }

  @override
  ThemeExtension<MGlobalStyles> copyWith({
    MColor? dividerColor,
    SnackBarThemeData? snackBarTheme,
    CheckboxThemeData? checkBoxTheme,
  }) {
    return MGlobalStyles(
      dividerColor: dividerColor ?? this.dividerColor,
      snackBarTheme: snackBarTheme ?? this.snackBarTheme,
      checkboxTheme: checkboxTheme ?? checkboxTheme,
    );
  }

  @override
  ThemeExtension<MGlobalStyles> lerp(
    ThemeExtension<MGlobalStyles>? other,
    double t,
  ) {
    if (other is! MGlobalStyles) return this;
    return MGlobalStyles(
      dividerColor: MColor.lerp(dividerColor, other.dividerColor, t),
      checkboxTheme:
          CheckboxThemeData.lerp(checkboxTheme, other.checkboxTheme, t),
      snackBarTheme:
          SnackBarThemeData.lerp(snackBarTheme, other.snackBarTheme, t),
    );
  }

  DividerThemeData get dividerTheme {
    return DividerThemeData(color: dividerColor, thickness: 1.0.toScale);
  }

  static MGlobalStyles? of(BuildContext context) {
    return Theme.of(context).extension<MGlobalStyles>();
  }
}
