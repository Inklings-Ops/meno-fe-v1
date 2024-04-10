import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../m_internal.dart';

class MCardStyles extends ThemeExtension<MCardStyles> {
  final MColor? backgroundColor;
  final MColor? titleColor;
  final MColor? hostColor;

  final MTextStyle? titleStyle;
  final MTextStyle? hostStyle;

  final MColor? nSubtitleColor;
  final MColor? nBackgroundColor;
  final EdgeInsetsGeometry? nCardContentPadding;
  final BorderRadiusGeometry? nBorderRadius;
  final MTextStyle? nTitleTextStyle;
  final MTextStyle? nSubtitleTextStyle;

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

  factory MCardStyles.$default({required MColorScheme colorScheme}) {
    final isLight = colorScheme.brightness == Brightness.light;
    return MCardStyles(
      backgroundColor: _resolve(isLight, MColor.white, MColor.primaryAlt),
      titleColor: colorScheme.onBackground,
      hostColor: _resolve(isLight, MColor.grey80, MColor.grey30),
      titleStyle: MTextStyle.captionMedium,
      hostStyle: MTextStyle.captionRegular,
      nSubtitleColor: colorScheme.onBackgroundVariant,
      nBackgroundColor: colorScheme.surfaceTint,
      nCardContentPadding: const EdgeInsets.symmetric(
        horizontal: MCore.small,
        vertical: MCore.large,
      ),
      nBorderRadius: BorderRadius.circular(16),
      nTitleTextStyle: MTextStyle.captionRegular,
      nSubtitleTextStyle: MTextStyle.microRegular,
    );
  }

  @override
  ThemeExtension<MCardStyles> copyWith({
    MColor? backgroundColor,
    MColor? titleColor,
    MColor? hostColor,
    MTextStyle? titleStyle,
    MTextStyle? hostStyle,
    MColor? nSubtitleColor,
    MColor? nBackgroundColor,
    EdgeInsetsGeometry? nCardContentPadding,
    BorderRadiusGeometry? nBorderRadius,
    MTextStyle? nTitleTextStyle,
    MTextStyle? nSubtitleTextStyle,
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
      titleStyle: MTextStyle.lerp(titleStyle, other.titleStyle, t),
      hostStyle: MTextStyle.lerp(hostStyle, other.hostStyle, t),
      nSubtitleColor: MColor.lerp(nSubtitleColor, other.nSubtitleColor, t),
      nBackgroundColor:
          MColor.lerp(nBackgroundColor, other.nBackgroundColor, t),
      nCardContentPadding: EdgeInsetsGeometry.lerp(
          nCardContentPadding, other.nCardContentPadding, t),
      nBorderRadius:
          BorderRadiusGeometry.lerp(nBorderRadius, other.nBorderRadius, t),
      nTitleTextStyle:
          MTextStyle.lerp(nTitleTextStyle, other.nTitleTextStyle, t),
      nSubtitleTextStyle:
          MTextStyle.lerp(nSubtitleTextStyle, other.nSubtitleTextStyle, t),
    );
  }

  CardTheme get cardTheme {
    return CardTheme(color: backgroundColor);
  }

  static MCardStyles? of(BuildContext context) {
    return Theme.of(context).extension<MCardStyles>();
  }
}
