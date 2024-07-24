import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/fonts.gen.dart';

class MTextTheme extends ThemeExtension<MTextTheme> {
  /// Heading 1 Regular
  final TextStyle? heading1Regular;

  /// Heading 1 Medium
  final TextStyle? heading1Medium;

  /// Heading 1 Bold
  final TextStyle? heading1Bold;

  /// Heading 2 Regular
  final TextStyle? heading2Regular;

  /// Heading 2 Medium
  final TextStyle? heading2Medium;

  /// Heading 2 Bold
  final TextStyle? heading2Bold;

  /// Heading 3 Regular
  final TextStyle? heading3Regular;

  /// Heading 3 Medium
  final TextStyle? heading3Medium;

  /// Heading 3 Bold
  final TextStyle? heading3Bold;

  /// Subheading Regular
  final TextStyle? subheadingRegular;

  /// Subheading Medium
  final TextStyle? subheadingMedium;

  /// Subheading Bold
  final TextStyle? subheadingBold;

  /// Body Regular
  final TextStyle? bodyRegular;

  /// Body Medium
  final TextStyle? bodyMedium;

  /// Body Bold
  final TextStyle? bodyBold;

  /// Caption Regular
  final TextStyle? captionRegular;

  /// Caption Medium
  final TextStyle? captionMedium;

  /// Caption Bold
  final TextStyle? captionBold;

  /// Micro Regular
  final TextStyle? microRegular;

  /// Micro Medium
  final TextStyle? microMedium;

  /// Micro Bold
  final TextStyle? microBold;

  /// Nano Regular
  final TextStyle? nanoRegular;

  /// Nano Medium
  final TextStyle? nanoMedium;

  /// Nano Bold
  final TextStyle? nanoBold;

  /// Button Medium
  final TextStyle? button;

  static const String fontFamily = FontFamily.sFProDisplay;

  factory MTextTheme.$default() {
    return MTextTheme(
      heading1Regular: $styles.text.heading1Regular,
      heading1Bold: $styles.text.heading1Bold,
      heading1Medium: $styles.text.heading1Medium,
      heading2Regular: $styles.text.heading2Regular,
      heading2Bold: $styles.text.heading2Bold,
      heading2Medium: $styles.text.heading2Medium,
      heading3Regular: $styles.text.heading3Regular,
      heading3Bold: $styles.text.heading3Bold,
      heading3Medium: $styles.text.heading3Medium,
      subheadingRegular: $styles.text.subheadingRegular,
      subheadingBold: $styles.text.subheadingBold,
      subheadingMedium: $styles.text.subheadingMedium,
      bodyRegular: $styles.text.bodyRegular,
      bodyBold: $styles.text.bodyBold,
      bodyMedium: $styles.text.bodyMedium,
      captionRegular: $styles.text.captionRegular,
      captionBold: $styles.text.captionBold,
      captionMedium: $styles.text.captionMedium,
      microRegular: $styles.text.microRegular,
      microBold: $styles.text.microBold,
      microMedium: $styles.text.microMedium,
      nanoRegular: $styles.text.nanoRegular,
      nanoBold: $styles.text.nanoBold,
      nanoMedium: $styles.text.nanoMedium,
      button: $styles.text.button,
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
      labelSmall: button, // Button
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
    this.button,
  });

  @override
  ThemeExtension<MTextTheme> copyWith({
    TextStyle? heading1Regular,
    TextStyle? heading1Bold,
    TextStyle? heading1Medium,
    TextStyle? heading2Regular,
    TextStyle? heading2Bold,
    TextStyle? heading2Medium,
    TextStyle? heading3Regular,
    TextStyle? heading3Bold,
    TextStyle? heading3Medium,
    TextStyle? subheadingRegular,
    TextStyle? subheadingBold,
    TextStyle? subheadingMedium,
    TextStyle? bodyRegular,
    TextStyle? bodyBold,
    TextStyle? bodyMedium,
    TextStyle? captionRegular,
    TextStyle? captionBold,
    TextStyle? captionMedium,
    TextStyle? microRegular,
    TextStyle? microBold,
    TextStyle? microMedium,
    TextStyle? nanoRegular,
    TextStyle? nanoBold,
    TextStyle? nanoMedium,
    TextStyle? button,
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
      button: button ?? this.button,
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
          TextStyle.lerp(heading1Regular, other.heading1Regular, t),
      heading1Medium: TextStyle.lerp(heading1Medium, other.heading1Medium, t),
      heading1Bold: TextStyle.lerp(heading1Bold, other.heading1Bold, t),
      heading2Regular:
          TextStyle.lerp(heading2Regular, other.heading2Regular, t),
      heading2Medium: TextStyle.lerp(heading2Medium, other.heading2Medium, t),
      heading2Bold: TextStyle.lerp(heading2Bold, other.heading2Bold, t),
      heading3Regular:
          TextStyle.lerp(heading3Regular, other.heading3Regular, t),
      heading3Medium: TextStyle.lerp(heading3Medium, other.heading3Medium, t),
      heading3Bold: TextStyle.lerp(heading3Bold, other.heading3Bold, t),
      subheadingRegular:
          TextStyle.lerp(subheadingRegular, other.subheadingRegular, t),
      subheadingMedium:
          TextStyle.lerp(subheadingMedium, other.subheadingMedium, t),
      subheadingBold: TextStyle.lerp(subheadingBold, other.subheadingBold, t),
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t),
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t),
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t),
      captionRegular: TextStyle.lerp(captionRegular, other.captionRegular, t),
      captionMedium: TextStyle.lerp(captionMedium, other.captionMedium, t),
      captionBold: TextStyle.lerp(captionBold, other.captionBold, t),
      microRegular: TextStyle.lerp(microRegular, other.microRegular, t),
      microMedium: TextStyle.lerp(microMedium, other.microMedium, t),
      microBold: TextStyle.lerp(microBold, other.microBold, t),
      nanoRegular: TextStyle.lerp(nanoRegular, other.nanoRegular, t),
      nanoMedium: TextStyle.lerp(nanoMedium, other.nanoMedium, t),
      nanoBold: TextStyle.lerp(nanoBold, other.nanoBold, t),
      button: TextStyle.lerp(button, other.button, t),
    );
  }

  static MTextTheme? of(context) => Theme.of(context).extension<MTextTheme>();
}
