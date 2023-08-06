import 'package:flutter/material.dart';

class MTextStyle {
  final TextStyle? textStyle;

  MTextStyle({this.textStyle});

  MTextStyle copyWith({TextStyle? textStyle}) {
    return MTextStyle(textStyle: textStyle ?? this.textStyle);
  }

  MTextStyle lerp(MTextStyle? other, double t) {
    return MTextStyle(
      textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
    );
  }
}

extension MTextStyleX on MTextStyle? {
  MTextStyle merge(MTextStyle? other) {
    if (this == null) return other ?? MTextStyle();
    return this!.copyWith(
      textStyle: this?.textStyle ?? other?.textStyle,
    );
  }
}
