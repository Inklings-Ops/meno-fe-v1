import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MAppBarStyles extends ThemeExtension<MAppBarStyles> {
  final MColor? textColor;
  final MColor? backgroundColor;
  final MColor? accentColor;
  final MTextStyle? textStyle;
  final MTextStyle? actionTextStyle;
  final IconThemeData? iconTheme;

  MAppBarStyles({
    this.textColor,
    this.backgroundColor,
    this.accentColor,
    this.textStyle,
    this.actionTextStyle,
    this.iconTheme,
  });

  factory MAppBarStyles.$default({required MColorScheme colorScheme}) {
    return MAppBarStyles(
      textColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      accentColor: MColor.secondary300,
      textStyle: MTextStyle.heading2Bold,
      actionTextStyle: MTextStyle.captionMedium,
      iconTheme: IconThemeData(color: colorScheme.primary, size: 24),
    );
  }

  @override
  ThemeExtension<MAppBarStyles> copyWith({
    MColor? textColor,
    MColor? backgroundColor,
    MColor? accentColor,
    MTextStyle? textStyle,
    MTextStyle? actionTextStyle,
    IconThemeData? iconTheme,
  }) {
    return MAppBarStyles(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
      textStyle: textStyle ?? this.textStyle,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      iconTheme: iconTheme ?? this.iconTheme,
    );
  }

  @override
  ThemeExtension<MAppBarStyles> lerp(MAppBarStyles? other, double t) {
    if (other is! MAppBarStyles) return this;
    return MAppBarStyles(
      textColor: MColor.lerp(backgroundColor, other.backgroundColor, t),
      backgroundColor: MColor.lerp(backgroundColor, other.backgroundColor, t),
      accentColor: MColor.lerp(accentColor, other.accentColor, t),
      textStyle: MTextStyle.lerp(textStyle, other.textStyle, t),
      actionTextStyle:
          MTextStyle.lerp(actionTextStyle, other.actionTextStyle, t),
      iconTheme: IconThemeData.lerp(iconTheme, other.iconTheme, t),
    );
  }

  static MAppBarStyles? of(BuildContext context) {
    return Theme.of(context).extension<MAppBarStyles>();
  }
}
