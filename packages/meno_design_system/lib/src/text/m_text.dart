import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MText extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    return DefaultTextStyle(
      style: effectiveTextStyle!.copyWith(color: color),
      child: Text(
        data,
        key: key,
        maxLines: maxLines,
        locale: locale,
        overflow: overflow,
        textAlign: textAlign,
        softWrap: softWrap,
      ),
    );
  }
}
