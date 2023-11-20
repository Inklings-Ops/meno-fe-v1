import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';
import 'm_text_style.dart';

class MTextTheme extends ThemeExtension<MTextTheme> {
  /// Heading 1 Regular
  final MTextStyle? heading1Regular;

  /// Heading 1 Medium
  final MTextStyle? heading1Medium;

  /// Heading 1 Bold
  final MTextStyle? heading1Bold;

  /// Heading 2 Regular
  final MTextStyle? heading2Regular;

  /// Heading 2 Medium
  final MTextStyle? heading2Medium;

  /// Heading 2 Bold
  final MTextStyle? heading2Bold;

  /// Heading 3 Regular
  final MTextStyle? heading3Regular;

  /// Heading 3 Medium
  final MTextStyle? heading3Medium;

  /// Heading 3 Bold
  final MTextStyle? heading3Bold;

  /// Subheading Regular
  final MTextStyle? subheadingRegular;

  /// Subheading Medium
  final MTextStyle? subheadingMedium;

  /// Subheading Bold
  final MTextStyle? subheadingBold;

  /// Body Regular
  final MTextStyle? bodyRegular;

  /// Body Medium
  final MTextStyle? bodyMedium;

  /// Body Bold
  final MTextStyle? bodyBold;

  /// Caption Regular
  final MTextStyle? captionRegular;

  /// Caption Medium
  final MTextStyle? captionMedium;

  /// Caption Bold
  final MTextStyle? captionBold;

  /// Micro Regular
  final MTextStyle? microRegular;

  /// Micro Medium
  final MTextStyle? microMedium;

  /// Micro Bold
  final MTextStyle? microBold;

  /// Nano Regular
  final MTextStyle? nanoRegular;

  /// Nano Medium
  final MTextStyle? nanoMedium;

  /// Nano Bold
  final MTextStyle? nanoBold;

  /// Button Medium
  final MTextStyle? buttonMedium;

  static const String fontFamily = FontFamily.sFProDisplay;

  factory MTextTheme.$default() {
    return const MTextTheme(
      heading1Regular: MTextStyle.heading1Regular,
      heading1Bold: MTextStyle.heading1Bold,
      heading1Medium: MTextStyle.heading1Medium,
      heading2Regular: MTextStyle.heading2Regular,
      heading2Bold: MTextStyle.heading2Bold,
      heading2Medium: MTextStyle.heading2Medium,
      heading3Regular: MTextStyle.heading3Regular,
      heading3Bold: MTextStyle.heading3Bold,
      heading3Medium: MTextStyle.heading3Medium,
      subheadingRegular: MTextStyle.subheadingRegular,
      subheadingBold: MTextStyle.subheadingBold,
      subheadingMedium: MTextStyle.subheadingMedium,
      bodyRegular: MTextStyle.bodyRegular,
      bodyBold: MTextStyle.bodyBold,
      bodyMedium: MTextStyle.bodyMedium,
      captionRegular: MTextStyle.captionRegular,
      captionBold: MTextStyle.captionBold,
      captionMedium: MTextStyle.captionMedium,
      microRegular: MTextStyle.microRegular,
      microBold: MTextStyle.microBold,
      microMedium: MTextStyle.microMedium,
      nanoRegular: MTextStyle.nanoRegular,
      nanoBold: MTextStyle.nanoBold,
      nanoMedium: MTextStyle.nanoMedium,
      buttonMedium: MTextStyle.buttonMedium,
    );
  }

  TextTheme get globalTextTheme {
    return TextTheme(
      headlineLarge: heading1Regular, // Heading 1
      headlineMedium: heading2Medium, // Heading 2
      headlineSmall: heading3Regular, // Heading 3
      titleMedium: subheadingRegular, // Subheading
      bodyLarge: bodyMedium, // Caption
      bodyMedium: bodyRegular, // Caption
      bodySmall: microRegular, // Micro
      labelMedium: nanoRegular, // Nano
      labelSmall: buttonMedium, // Button
    );
  }

  const MTextTheme({
    this.heading1Regular,
    this.heading1Bold,
    this.heading1Medium,
    this.heading2Regular,
    this.heading2Bold,
    this.heading2Medium,
    this.heading3Regular,
    this.heading3Bold,
    this.heading3Medium,
    this.subheadingRegular,
    this.subheadingBold,
    this.subheadingMedium,
    this.bodyRegular,
    this.bodyBold,
    this.bodyMedium,
    this.captionRegular,
    this.captionBold,
    this.captionMedium,
    this.microRegular,
    this.microBold,
    this.microMedium,
    this.nanoRegular,
    this.nanoBold,
    this.nanoMedium,
    this.buttonMedium,
  });

  @override
  ThemeExtension<MTextTheme> copyWith({
    MTextStyle? heading1Regular,
    MTextStyle? heading1Bold,
    MTextStyle? heading1Medium,
    MTextStyle? heading2Regular,
    MTextStyle? heading2Bold,
    MTextStyle? heading2Medium,
    MTextStyle? heading3Regular,
    MTextStyle? heading3Bold,
    MTextStyle? heading3Medium,
    MTextStyle? subheadingRegular,
    MTextStyle? subheadingBold,
    MTextStyle? subheadingMedium,
    MTextStyle? bodyRegular,
    MTextStyle? bodyBold,
    MTextStyle? bodyMedium,
    MTextStyle? captionRegular,
    MTextStyle? captionBold,
    MTextStyle? captionMedium,
    MTextStyle? microRegular,
    MTextStyle? microBold,
    MTextStyle? microMedium,
    MTextStyle? nanoRegular,
    MTextStyle? nanoBold,
    MTextStyle? nanoMedium,
    MTextStyle? buttonMedium,
  }) {
    return MTextTheme(
      heading1Regular: heading1Regular ?? this.heading1Regular,
      heading1Bold: heading1Bold ?? this.heading1Bold,
      heading1Medium: heading1Medium ?? this.heading1Medium,
      heading2Regular: heading2Regular ?? this.heading2Regular,
      heading2Bold: heading2Bold ?? this.heading2Bold,
      heading2Medium: heading2Medium ?? this.heading2Medium,
      heading3Regular: heading3Regular ?? this.heading3Regular,
      heading3Bold: heading3Bold ?? this.heading3Bold,
      heading3Medium: heading3Medium ?? this.heading3Medium,
      subheadingRegular: subheadingRegular ?? this.subheadingRegular,
      subheadingBold: subheadingBold ?? this.subheadingBold,
      subheadingMedium: subheadingMedium ?? this.subheadingMedium,
      bodyRegular: bodyRegular ?? this.bodyRegular,
      bodyBold: bodyBold ?? this.bodyBold,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      captionRegular: captionRegular ?? this.captionRegular,
      captionBold: captionBold ?? this.captionBold,
      captionMedium: captionMedium ?? this.captionMedium,
      microRegular: microRegular ?? this.microRegular,
      microBold: microBold ?? this.microBold,
      microMedium: microMedium ?? this.microMedium,
      nanoRegular: nanoRegular ?? this.nanoRegular,
      nanoBold: nanoBold ?? this.nanoBold,
      nanoMedium: nanoMedium ?? this.nanoMedium,
      buttonMedium: buttonMedium ?? this.buttonMedium,
    );
  }

  @override
  ThemeExtension<MTextTheme> lerp(
    covariant ThemeExtension<MTextTheme>? other,
    double t,
  ) {
    if (other is! MTextTheme) return this;
    return MTextTheme(
      heading1Regular:
          MTextStyle.lerp(heading1Regular, other.heading1Regular, t),
      heading1Medium: MTextStyle.lerp(heading1Medium, other.heading1Medium, t),
      heading1Bold: MTextStyle.lerp(heading1Bold, other.heading1Bold, t),
      heading2Regular:
          MTextStyle.lerp(heading2Regular, other.heading2Regular, t),
      heading2Medium: MTextStyle.lerp(heading2Medium, other.heading2Medium, t),
      heading2Bold: MTextStyle.lerp(heading2Bold, other.heading2Bold, t),
      heading3Regular:
          MTextStyle.lerp(heading3Regular, other.heading3Regular, t),
      heading3Medium: MTextStyle.lerp(heading3Medium, other.heading3Medium, t),
      heading3Bold: MTextStyle.lerp(heading3Bold, other.heading3Bold, t),
      subheadingRegular:
          MTextStyle.lerp(subheadingRegular, other.subheadingRegular, t),
      subheadingMedium:
          MTextStyle.lerp(subheadingMedium, other.subheadingMedium, t),
      subheadingBold: MTextStyle.lerp(subheadingBold, other.subheadingBold, t),
      bodyRegular: MTextStyle.lerp(bodyRegular, other.bodyRegular, t),
      bodyMedium: MTextStyle.lerp(bodyMedium, other.bodyMedium, t),
      bodyBold: MTextStyle.lerp(bodyBold, other.bodyBold, t),
      captionRegular: MTextStyle.lerp(captionRegular, other.captionRegular, t),
      captionMedium: MTextStyle.lerp(captionMedium, other.captionMedium, t),
      captionBold: MTextStyle.lerp(captionBold, other.captionBold, t),
      microRegular: MTextStyle.lerp(microRegular, other.microRegular, t),
      microMedium: MTextStyle.lerp(microMedium, other.microMedium, t),
      microBold: MTextStyle.lerp(microBold, other.microBold, t),
      nanoRegular: MTextStyle.lerp(nanoRegular, other.nanoRegular, t),
      nanoMedium: MTextStyle.lerp(nanoMedium, other.nanoMedium, t),
      nanoBold: MTextStyle.lerp(nanoBold, other.nanoBold, t),
      buttonMedium: MTextStyle.lerp(buttonMedium, other.buttonMedium, t),
    );
  }

  static MTextTheme? of(context) => Theme.of(context).extension<MTextTheme>();
}
