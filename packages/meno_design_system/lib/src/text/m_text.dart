import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Custom thickness of the glyphs used to draw the text.
enum MFontWeight {
  /// [FontWeight.normal] or [FontWeight.w400]
  regular,

  /// [FontWeight.w500]
  medium,

  /// [FontWeight.bold] or [FontWeight.w700]
  bold,
}

/// {@template meno_text}
/// A run of text with a single style.
/// {@endtemplate}
class MText extends StatelessWidget {
  /// {@macro meno_text}
  const MText(
    this.data, {
    super.key,
    this.fontSize,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.weight = MFontWeight.medium,
    this.style,
    this.decoration,
    this.color,
    this.decorationColor,
    this.height,
    this.letterSpacing,
  });

  const MText._(
    this.data, {
    required this.fontSize,
    super.key,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.weight = MFontWeight.medium,
    this.style,
    this.decoration,
    this.color,
    this.decorationColor,
    this.height,
    this.letterSpacing,
  });

  /// Heading 1
  const factory MText.heading1(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Heading1;

  /// Heading 2
  const factory MText.heading2(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Heading2;

  /// Heading 3
  const factory MText.heading3(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Heading3;

  /// Subheading
  const factory MText.subheading(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Subheading;

  /// Body
  const factory MText.body(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Body;

  /// Caption
  const factory MText.caption(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Caption;

  /// Micro
  const factory MText.micro(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Micro;

  /// Nano
  const factory MText.nano(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Nano;

  /// Button
  const factory MText.button(
    String data, {
    Key? key,
    MFontWeight weight,
    Color? color,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextDecoration? decoration,
    Color? decorationColor,
    bool? softWrap,
    double fontSize,
    double? height,
    double? letterSpacing,
    TextStyle? style,
  }) = _Button;

  /// The text to display.
  final String data;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with
  /// `Localizations.localeOf(context)`.
  ///
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// An optional maximum number of lines for the text to span, wrapping
  /// if necessary.
  /// If the text exceeds the given number of lines, it will be truncated
  /// according to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels
  /// applied directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// const Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// Override of the normal text style
  final TextStyle? style;

  /// Custom font weight for the text
  final MFontWeight weight;

  /// Convenient way to set the color of the text without copying the style
  final Color? color;

  /// [TextDecoration]
  final TextDecoration? decoration;

  /// [TextDecoration] color
  final Color? decorationColor;

  /// The size of fonts (in logical pixels) to use when painting the text.
  final double? fontSize;

  /// The height of this text span, as a multiple of the font size.
  final double? height;

  /// The amount of space (in logical pixels) to add between each letter.
  /// A negative value can be used to bring the letters closer.
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }

    return Text(
      data,
      key: key,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
      style: effectiveTextStyle?.copyWith(
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        fontSize: effectiveTextStyle.fontSize?.sp ?? fontSize?.sp,
        fontWeight: switch (weight) {
          MFontWeight.regular => FontWeight.w400,
          MFontWeight.medium => FontWeight.w500,
          MFontWeight.bold => FontWeight.bold,
        },
        height: height?.h ?? effectiveTextStyle.height?.h,
        letterSpacing: letterSpacing?.w ?? effectiveTextStyle.letterSpacing?.w,
      ),
    );
  }
}

class _Heading1 extends MText {
  const _Heading1(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 32,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.heading1);
}

class _Heading2 extends MText {
  const _Heading2(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 24,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.heading2);
}

class _Heading3 extends MText {
  const _Heading3(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 20,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.heading3);
}

class _Subheading extends MText {
  const _Subheading(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 16,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.subheading);
}

class _Body extends MText {
  const _Body(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 16,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.body);
}

class _Caption extends MText {
  const _Caption(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 14,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.caption);
}

class _Micro extends MText {
  const _Micro(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 12,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.micro);
}

class _Nano extends MText {
  const _Nano(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 10,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.nano);
}

class _Button extends MText {
  const _Button(
    super.data, {
    super.key,
    super.weight,
    super.color,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.overflow,
    super.maxLines,
    super.semanticsLabel,
    super.decoration,
    super.decorationColor,
    super.softWrap,
    super.fontSize = 8,
    super.height,
    super.letterSpacing,
    TextStyle? style,
  }) : super._(style: style ?? MTextStyles.button);
}
