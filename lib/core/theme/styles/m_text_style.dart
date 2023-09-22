import 'dart:ui';

import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';

class MTextStyle extends ThemeExtension<MTextStyle> {
  final String? debugLabel;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final String? fontFamily;

  const MTextStyle._({
    this.debugLabel,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.fontFamily,
  });

  static MTextStyle? of(BuildContext context) {
    return Theme.of(context).extension<MTextStyle>();
  }

  static const String _fontFamily = FontFamily.sFProDisplay;

  // Heading 1
  static const heading1Bold = MTextStyle._(
    fontFamily: _fontFamily,
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w700,
    debugLabel: "Heading 1 Bold",
  );

  static const heading1Medium = MTextStyle._(
    fontFamily: _fontFamily,
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w500,
    debugLabel: "Heading 1 Medium",
  );

  static const heading1Regular = MTextStyle._(
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w400,
    debugLabel: "Heading 1 Regular",
  );

  // Heading 2
  static const TextStyle heading2Bold = TextStyle(
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    debugLabel: "Heading 2 Bold",
  );

  static const TextStyle heading2Medium = TextStyle(
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Heading 2 Medium",
  );

  static const TextStyle heading2Regular = TextStyle(
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    debugLabel: "Heading 2 Regular",
  );

  // Subheading
  static const TextStyle subheadingBold = TextStyle(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    debugLabel: "Subheading Bold",
  );

  static const TextStyle subheadingMedium = TextStyle(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Subheading Medium",
  );

  static const TextStyle subheadingRegular = TextStyle(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    debugLabel: "Subheading Regular",
  );

  // Body
  static const TextStyle bodyBold = TextStyle(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    debugLabel: "Body Bold",
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Body Medium",
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    debugLabel: "Body Regular",
  );

  // Caption
  static const TextStyle captionBold = TextStyle(
    fontSize: 14.0,
    height: 16.0 / 14.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    debugLabel: "Caption Bold",
  );
  static const TextStyle captionMedium = TextStyle(
    fontSize: 14.0,
    height: 16.0 / 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Caption Medium",
  );

  static const TextStyle captionRegular = TextStyle(
    fontSize: 14.0,
    height: 16.0 / 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    debugLabel: "Caption Regular",
  );

  // Micro
  static const TextStyle microBold = TextStyle(
    fontSize: 12.0,
    height: 16.0 / 12.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    debugLabel: "Micro Bold",
  );

  static const TextStyle microMedium = TextStyle(
    fontSize: 12.0,
    height: 16.0 / 12.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Micro Medium",
  );

  static const TextStyle microRegular = TextStyle(
    fontSize: 12.0,
    height: 16.0 / 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    debugLabel: "Micro Regular",
  );

  // Nano
  static const TextStyle nanoBold = TextStyle(
    fontSize: 10.0,
    height: 14.0 / 10.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    debugLabel: "Nano Bold",
  );
  static const TextStyle nanoMedium = TextStyle(
    fontSize: 10.0,
    height: 14.0 / 10.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Nano Medium",
  );

  static const TextStyle nanoRegular = TextStyle(
    fontSize: 10.0,
    height: 14.0 / 10.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    debugLabel: "Nano Regular",
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 8.0,
    height: 16.0 / 8.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    debugLabel: "Button Medium",
  );

  @override
  ThemeExtension<MTextStyle> copyWith({
    String? debugLabel,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return MTextStyle._(
      debugLabel: debugLabel ?? this.debugLabel,
      fontSize: fontSize ?? this.fontSize,
      height: height ?? this.height,
      fontWeight: fontWeight ?? this.fontWeight,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  ThemeExtension<MTextStyle> lerp(ThemeExtension<MTextStyle>? other, double t) {
    if (other is! MTextStyle) {
      return this;
    }

    return MTextStyle._(
      debugLabel: other.debugLabel,
      fontSize: lerpDouble(fontSize, other.fontSize, t),
      height: lerpDouble(height, other.height, t),
      fontWeight: FontWeight.lerp(fontWeight, other.fontWeight, t),
      fontFamily: other.fontFamily,
    );
  }
}

extension MTextThemeX on MTextStyle? {
  TextStyle get toTextStyle {
    return TextStyle(
      debugLabel: this?.debugLabel,
      fontSize: this?.fontSize,
      height: this?.height,
      fontWeight: this?.fontWeight,
      fontFamily: this?.fontFamily,
    );
  }
}
