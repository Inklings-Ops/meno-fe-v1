import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';

class MTextStyle extends TextStyle {
  const MTextStyle._({
    super.fontSize,
    super.height,
    super.fontWeight,
    super.fontFamily,
    super.textBaseline,
    super.letterSpacing,
  });

  static MTextStyle? of(BuildContext context) {
    return Theme.of(context).extension<MTextStyle>();
  }

  static const String _fontFamily = FontFamily.sFProDisplay;

  // CountDown TextStyle
  static const countDown = MTextStyle._(
    fontSize: 72.0,
    height: 1.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0.18,
  );

  // Heading 1
  static const heading1Bold = MTextStyle._(
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  static const heading1Medium = MTextStyle._(
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  static const heading1Regular = MTextStyle._(
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  // Heading 2
  static const MTextStyle heading2Bold = MTextStyle._(
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  static const MTextStyle heading2Medium = MTextStyle._(
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  static const MTextStyle heading2Regular = MTextStyle._(
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  // Heading 3
  static const MTextStyle heading3Bold = MTextStyle._(
      fontSize: 20.0,
      height: 24.0 / 20.0,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0
      // letterSpacing: 0.0,
      );

  static const MTextStyle heading3Medium = MTextStyle._(
      fontSize: 20.0,
      height: 24.0 / 20.0,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0
      // letterSpacing: 0.0,
      );

  static const MTextStyle heading3Regular = MTextStyle._(
      fontSize: 20.0,
      height: 24.0 / 20.0,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0
      // letterSpacing: 0.0,
      );

  // Subheading
  static const MTextStyle subheadingBold = MTextStyle._(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.15,
  );

  static const MTextStyle subheadingMedium = MTextStyle._(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.15,
  );

  static const MTextStyle subheadingRegular = MTextStyle._(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.15,
  );

  // Body
  static const MTextStyle bodyBold = MTextStyle._(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.16,
  );

  static const MTextStyle bodyMedium = MTextStyle._(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.16,
  );

  static const MTextStyle bodyRegular = MTextStyle._(
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.16,
  );

  // Caption
  static const MTextStyle captionBold = MTextStyle._(
    fontSize: 14.0,
    height: 16.0 / 14.0,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );
  static const MTextStyle captionMedium = MTextStyle._(
    fontSize: 14.0,
    height: 16.0 / 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  static const MTextStyle captionRegular = MTextStyle._(
    fontSize: 14.0,
    // height: 16.0 / 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0,
    // letterSpacing: 0.25,
  );

  // Micro
  static const MTextStyle microBold = MTextStyle._(
      fontSize: 12.0,
      height: 16.0 / 12.0,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0
      // letterSpacing: 0.4,
      );

  static const MTextStyle microMedium = MTextStyle._(
      fontSize: 12.0,
      height: 16.0 / 12.0,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0
      // letterSpacing: 0.4,
      );

  static const MTextStyle microRegular = MTextStyle._(
      fontSize: 12.0,
      height: 16.0 / 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0
      // letterSpacing: 0.4,
      );

  // Nano
  static const MTextStyle nanoBold = MTextStyle._(
      fontSize: 10.0,
      height: 14.0 / 10.0,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1
      // letterSpacing: 1.5,
      );
  static const MTextStyle nanoMedium = MTextStyle._(
      fontSize: 10.0,
      height: 14.0 / 10.0,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1
      // letterSpacing: 1.5,
      );

  static const MTextStyle nanoRegular = MTextStyle._(
      fontSize: 10.0,
      height: 14.0 / 10.0,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1
      // letterSpacing: 1.5,
      );

  static const MTextStyle buttonMedium = MTextStyle._(
    fontSize: 8.0,
    height: 16.0 / 8.0,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
  );

  static MTextStyle? lerp(MTextStyle? a, MTextStyle? b, double t) {
    if (a == null) {
      return MTextStyle._(
        fontFamily: t < 0.5 ? null : b?.fontFamily,
        fontSize: t < 0.5 ? null : b?.fontSize,
        fontWeight: FontWeight.lerp(null, b?.fontWeight, t),
        height: t < 0.5 ? null : b?.height,
      );
    }

    if (b == null) {
      return MTextStyle._(
        fontSize: t < 0.5 ? a.fontSize : null,
        fontWeight: FontWeight.lerp(a.fontWeight, null, t),
        height: t < 0.5 ? a.height : null,
        fontFamily: t < 0.5 ? a.fontFamily : null,
      );
    }
    return MTextStyle._(
      fontSize:
          ui.lerpDouble(a.fontSize ?? b.fontSize, b.fontSize ?? a.fontSize, t),
      fontWeight: FontWeight.lerp(a.fontWeight, b.fontWeight, t),
      height: ui.lerpDouble(a.height ?? b.height, b.height ?? a.height, t),
      fontFamily: t < 0.5 ? a.fontFamily : b.fontFamily,
    );
  }
}

extension MTextThemeX on MTextStyle? {
  TextStyle get toTextStyle {
    return TextStyle(
      fontSize: this?.fontSize,
      height: this?.height,
      fontWeight: this?.fontWeight,
      fontFamily: this?.fontFamily,
    );
  }
}
