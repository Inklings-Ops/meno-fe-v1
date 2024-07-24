import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../m_internal.dart';

class MCardStyles extends ThemeExtension<MCardStyles> {
  final MColor? backgroundColor;
  final MColor? titleColor;
  final MColor? hostColor;

  final TextStyle? titleStyle;
  final TextStyle? hostStyle;

  final MColor? nSubtitleColor;
  final MColor? nBackgroundColor;
  final EdgeInsetsGeometry? nCardContentPadding;
  final BorderRadiusGeometry? nBorderRadius;
  final TextStyle? nTitleTextStyle;
  final TextStyle? nSubtitleTextStyle;

  MCardStyles({
    this.backgroundColor,
    this.titleColor,
    this.hostColor,
    this.titleStyle,
    this.hostStyle,
    this.nSubtitleColor,
    this.nBackgroundColor,
    this.nCardContentPadding,
    this.nBorderRadius,
    this.nTitleTextStyle,
    this.nSubtitleTextStyle,
  });

  static T _resolve<T>(isLight, a, b) => MInternal.resolve(isLight, a, b);

  factory MCardStyles.$default(MColorScheme colors) {
    final isLight = colors.brightness == Brightness.light;
    return MCardStyles(
      backgroundColor: _resolve(isLight, MColor.white, MColor.primaryAlt),
      titleColor: colors.onBackground,
      hostColor: _resolve(isLight, MColor.grey80, MColor.grey30),
      titleStyle: $styles.text.captionMedium,
      hostStyle: $styles.text.captionRegular,
      nSubtitleColor: colors.onBackgroundVariant,
      nBackgroundColor: colors.surfaceTint,
      nCardContentPadding: EdgeInsets.symmetric(
        horizontal: $styles.insets.small,
        vertical: $styles.insets.large,
      ),
      nBorderRadius: $styles.radius.large,
      nTitleTextStyle: $styles.text.captionRegular,
      nSubtitleTextStyle: $styles.text.microRegular,
    );
  }

  @override
  ThemeExtension<MCardStyles> copyWith({
    MColor? backgroundColor,
    MColor? titleColor,
    MColor? hostColor,
    TextStyle? titleStyle,
    TextStyle? hostStyle,
    MColor? nSubtitleColor,
    MColor? nBackgroundColor,
    EdgeInsetsGeometry? nCardContentPadding,
    BorderRadiusGeometry? nBorderRadius,
    TextStyle? nTitleTextStyle,
    TextStyle? nSubtitleTextStyle,
  }) {
    return MCardStyles(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      hostColor: hostColor ?? this.hostColor,
      titleStyle: titleStyle ?? this.titleStyle,
      hostStyle: hostStyle ?? this.hostStyle,
      nSubtitleColor: nSubtitleColor ?? this.nSubtitleColor,
      nBackgroundColor: nBackgroundColor ?? this.nBackgroundColor,
      nCardContentPadding: nCardContentPadding ?? this.nCardContentPadding,
      nBorderRadius: nBorderRadius ?? this.nBorderRadius,
      nTitleTextStyle: nTitleTextStyle ?? this.nTitleTextStyle,
      nSubtitleTextStyle: nSubtitleTextStyle ?? this.nSubtitleTextStyle,
    );
  }

  @override
  ThemeExtension<MCardStyles> lerp(MCardStyles? other, double t) {
    if (other is! MCardStyles) return this;
    return MCardStyles(
      backgroundColor: MColor.lerp(backgroundColor, other.backgroundColor, t),
      titleColor: MColor.lerp(titleColor, other.titleColor, t),
      hostColor: MColor.lerp(hostColor, other.hostColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      hostStyle: TextStyle.lerp(hostStyle, other.hostStyle, t),
      nSubtitleColor: MColor.lerp(nSubtitleColor, other.nSubtitleColor, t),
      nBackgroundColor:
          MColor.lerp(nBackgroundColor, other.nBackgroundColor, t),
      nCardContentPadding: EdgeInsetsGeometry.lerp(
          nCardContentPadding, other.nCardContentPadding, t),
      nBorderRadius:
          BorderRadiusGeometry.lerp(nBorderRadius, other.nBorderRadius, t),
      nTitleTextStyle:
          TextStyle.lerp(nTitleTextStyle, other.nTitleTextStyle, t),
      nSubtitleTextStyle:
          TextStyle.lerp(nSubtitleTextStyle, other.nSubtitleTextStyle, t),
    );
  }

  CardTheme get cardTheme {
    return CardTheme(color: backgroundColor);
  }

  static MCardStyles? of(BuildContext context) {
    return Theme.of(context).extension<MCardStyles>();
  }
}
