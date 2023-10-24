import 'package:flutter/material.dart';

import '../m_color.dart';
import '../m_color_scheme.dart';
import 'm_text_style.dart';

class MGlobalStyles extends ThemeExtension<MGlobalStyles> {
  final MColor? dividerColor;
  final SnackBarThemeData? snackBarTheme;
  final CheckboxThemeData? checkboxTheme;

  MGlobalStyles({
    this.dividerColor,
    this.snackBarTheme,
    this.checkboxTheme,
  });

  factory MGlobalStyles.$default({required MColorScheme colorScheme}) {
    return MGlobalStyles(
      dividerColor: colorScheme.outlineVariant1,
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(width: 1, color: colorScheme.outlineVariant1!),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: MTextStyle.captionRegular,
        insetPadding: EdgeInsets.all(16),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
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
    return DividerThemeData(color: dividerColor, thickness: 1.0);
  }

  static MGlobalStyles? of(BuildContext context) {
    return Theme.of(context).extension<MGlobalStyles>();
  }
}
