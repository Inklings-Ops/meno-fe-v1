import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/fonts.gen.dart';

const double _micro = 4;
const double _small = 8;
const double _medium = 12;
const double _large = 16;
const double _xLarge = 20;
const double _xxLarge = 32;
const double _xxxLarge = 48;
const double _circle = 555;

class Styles {
  late final double scale;
  late final MColorScheme? colors;

  Styles({BuildContext? context}) {
    scale = _computeScale(context);
    colors = _computeColorScheme(context);
  }

  late final insets = _Insets(scale);
  late final radius = _Radius(scale);
  late final shadows = _Shadows(scale);
  late final spaces = _Spaces(scale);
  late final text = _Text(scale, colors);
  late final toolbarHeight = _ToolBarHeights(scale);
}

@immutable
class _Insets {
  final double _scale;
  late final double micro = _micro * _scale;
  late final double small = _small * _scale;
  late final double medium = _medium * _scale;
  late final double large = _large * _scale;
  late final double xLarge = _xLarge * _scale;
  late final double xxLarge = _xxLarge * _scale;
  late final double xxxLarge = _xxxLarge * _scale;
  late final double circle = _circle * _scale;
  _Insets(this._scale);
}

@immutable
class _Radius {
  final double _scale;
  late final BorderRadius micro = _radius(_micro * _scale);
  late final BorderRadius small = _radius(_small * _scale);
  late final BorderRadius medium = _radius(_medium * _scale);
  late final BorderRadius large = _radius(_large * _scale);
  late final BorderRadius xLarge = _radius(_xLarge * _scale);
  late final BorderRadius xxLarge = _radius(_xxLarge * _scale);
  late final BorderRadius xxxLarge = _radius(_xxxLarge * _scale);
  late final BorderRadius circle = _radius(_circle * _scale);
  late final squircleLarge = _squircleRadius(_large * _scale);
  _Radius(this._scale);
}

@immutable
class _Shadows {
  final double _scale;
  late final double _blurRadius = 10 * _scale;
  late final double _spreadRadius = 2 * _scale;
  late final soft = [
    BoxShadow(
      color: const Color(0x0C000000),
      offset: Offset(0, 2 * _scale),
      blurRadius: _blurRadius,
      spreadRadius: _spreadRadius,
    )
  ];
  late final medium = [
    BoxShadow(
      color: const Color(0x14000000),
      offset: Offset(0, 6 * _scale),
      blurRadius: _blurRadius,
      spreadRadius: 4 * _scale,
    )
  ];
  late final strong = [
    BoxShadow(
      color: const Color(0x14000000),
      offset: Offset(0, 8 * _scale),
      blurRadius: _blurRadius,
      spreadRadius: _spreadRadius,
    ),
    BoxShadow(
      color: const Color(0x14000000),
      offset: Offset(0, -1 * _scale),
      blurRadius: 12 * _scale,
      spreadRadius: 0,
    )
  ];
  late final mic = [
    BoxShadow(
      color: const Color(0x4B360090),
      blurRadius: 8 * _scale,
      offset: Offset(0, 5 * _scale),
      spreadRadius: 1 * _scale,
    ),
  ];
  _Shadows(this._scale);
}

@immutable
class _Spaces {
  final double _scale;
  // Horizontal Spaces
  late final SizedBox horizontalMicro = SizedBox(width: _micro * _scale);
  late final SizedBox horizontalSmall = SizedBox(width: _small * _scale);
  late final SizedBox horizontalMedium = SizedBox(width: _medium * _scale);
  late final SizedBox horizontalLarge = SizedBox(width: _large * _scale);
  late final SizedBox horizontalXLarge = SizedBox(width: _xLarge * _scale);
  late final SizedBox horizontalXXLarge = SizedBox(width: _xxLarge * _scale);
  late final SizedBox horizontalXXXLarge = SizedBox(width: _xxxLarge * _scale);
  // Vertical Spaces
  late final SizedBox verticalMicro = SizedBox(height: _micro * _scale);
  late final SizedBox verticalSmall = SizedBox(height: _small * _scale);
  late final SizedBox verticalMedium = SizedBox(height: _medium * _scale);
  late final SizedBox verticalLarge = SizedBox(height: _large * _scale);
  late final SizedBox verticalXLarge = SizedBox(height: _xLarge * _scale);
  late final SizedBox verticalXXLarge = SizedBox(height: _xxLarge * _scale);
  late final SizedBox verticalXXXLarge = SizedBox(height: _xxxLarge * _scale);
  _Spaces(this._scale);
}

@immutable
class _Text {
  final double _scale;
  final MColorScheme? _colors;
  late final heading1Regular = _font(size: 32, height: 40);
  late final heading1Medium =
      heading1Regular.copyWith(fontWeight: FontWeight.w600);
  late final heading1Bold =
      heading1Regular.copyWith(fontWeight: FontWeight.w700);
  late final heading2Regular = _font(size: 24, height: 32);
  late final heading2Medium =
      heading2Regular.copyWith(fontWeight: FontWeight.w600);
  late final heading2Bold =
      heading2Regular.copyWith(fontWeight: FontWeight.w700);
  late final heading3Regular = _font(size: 20, height: 24);
  late final heading3Medium =
      heading3Regular.copyWith(fontWeight: FontWeight.w600);
  late final heading3Bold =
      heading3Regular.copyWith(fontWeight: FontWeight.w700);
  late final subheadingRegular = _font(size: 16, height: 24);
  late final subheadingMedium =
      subheadingRegular.copyWith(fontWeight: FontWeight.w600);
  late final subheadingBold =
      subheadingRegular.copyWith(fontWeight: FontWeight.w700);
  late final bodyRegular = _font(size: 16, height: 24);
  late final bodyMedium = bodyRegular.copyWith(fontWeight: FontWeight.w600);
  late final bodyBold = bodyRegular.copyWith(fontWeight: FontWeight.w700);
  late final captionRegular = _font(size: 14, height: 16);
  late final captionMedium =
      captionRegular.copyWith(fontWeight: FontWeight.w600);
  late final captionBold = captionRegular.copyWith(fontWeight: FontWeight.w700);
  late final microRegular = _font(size: 12, height: 16);
  late final microMedium = microRegular.copyWith(fontWeight: FontWeight.w600);
  late final microBold = microRegular.copyWith(fontWeight: FontWeight.w700);
  late final nanoRegular = _font(size: 10, height: 14);
  late final nanoMedium = nanoRegular.copyWith(fontWeight: FontWeight.w600);
  late final nanoBold = nanoRegular.copyWith(fontWeight: FontWeight.w700);
  late final button = _font(size: 8, height: 16, weight: FontWeight.w600);
  late final countDown = _font(size: 72, weight: FontWeight.w700);
  _Text(this._scale, this._colors);
  TextStyle get _style => const TextStyle(fontFamily: FontFamily.sFProDisplay);
  TextStyle _font({
    required double size,
    double? height,
    FontWeight? weight,
    TextDecoration? decoration,
  }) {
    size *= _scale;
    if (height != null) {
      height *= _scale;
    }
    // final sp = spacing != null ? size * spacing * 0.01 : _style.letterSpacing;
    return _style.copyWith(
      fontSize: size,
      height: height != null ? (height / size) : _style.height,
      fontWeight: weight ?? FontWeight.w500,
      decoration: decoration,
      letterSpacing: _style.letterSpacing,
      color: _colors?.onBackground,
    );
  }
}

@immutable
class _ToolBarHeights {
  final double _scale;
  late final Size home = Size.fromHeight(64 * _scale);
  late final Size primary = Size.fromHeight(120 * _scale);
  late final Size secondary = Size.fromHeight(56 * _scale);
  _ToolBarHeights(this._scale);
}

double _computeScale(BuildContext? context) {
  if (context == null) return 1;
  final shortestSide = MediaQuery.sizeOf(context).shortestSide;
  // If larger than an extra large tablet
  if (shortestSide > 1000) {
    return 1.3;
    // If large than a large tablet
  } else if (shortestSide > 800) {
    return 1.2;
  } else {
    return 1;
  }
}

MColorScheme? _computeColorScheme(BuildContext? context) {
  if (context == null) {
    return null;
  } else {
    final brightness = MediaQuery.platformBrightnessOf(context);
    MTheme.createTheme(brightness);
    return MColorScheme.of(context);
  }
}

BorderRadius _radius(double r) => BorderRadius.all(Radius.circular(r));

SmoothBorderRadius _squircleRadius(double r) {
  return SmoothBorderRadius(cornerRadius: r, cornerSmoothing: 1);
}

extension StyleX on num {
  double get toScale => this * $styles.scale;
  SizedBox get hSpace => SizedBox(width: this * $styles.scale);
  SizedBox get vSpace => SizedBox(height: this * $styles.scale);
}

extension EdgeInsetsX on EdgeInsets {
  EdgeInsets get radius => copyWith(
        top: top.toScale,
        bottom: bottom.toScale,
        right: right.toScale,
        left: left.toScale,
      );
}

extension BoxConstraintsX on BoxConstraints {
  BoxConstraints get radius => copyWith(
        maxHeight: maxHeight.toScale,
        maxWidth: maxWidth.toScale,
        minHeight: minHeight.toScale,
        minWidth: minWidth.toScale,
      );
}

extension BorderRadiusExtension on BorderRadius {
  BorderRadius get radius => copyWith(
        bottomLeft: bottomLeft.radius,
        bottomRight: bottomRight.radius,
        topLeft: topLeft.radius,
        topRight: topRight.radius,
      );
}

extension RadiusExtension on Radius {
  Radius get radius => Radius.elliptical(x.toScale, y.toScale);
}
