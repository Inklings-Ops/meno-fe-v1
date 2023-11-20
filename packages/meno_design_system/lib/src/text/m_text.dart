import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MText extends StatelessWidget {
  final String data;
  final MColor? color;
  final TextStyle? style;
  final int? maxLines;
  final Locale? locale;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final MColor? decorationColor;
  final double? decorationThickness;
  final bool? softWrap;

  const MText(
    this.data, {
    super.key,
    this.color,
    this.style,
    this.maxLines,
    this.locale,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      key: key,
      maxLines: maxLines,
      locale: locale,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
      style: TextStyle(
        color: color,
        fontFamily: style?.fontFamily,
        fontSize: style?.fontSize,
        fontWeight: style?.fontWeight,
        height: style?.height,
        debugLabel: style?.debugLabel,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        letterSpacing: style?.letterSpacing,
        textBaseline: style?.textBaseline,
      ),
    );
  }
}
