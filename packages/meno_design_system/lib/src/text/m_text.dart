import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MText extends Text {
  MText(
    super.data, {
    Key? key,
    MColor? color,
    MTextStyle? style,
    super.maxLines = 1,
    super.locale,
    super.overflow = TextOverflow.ellipsis,
    super.textAlign,
  }) : super(
          key: key,
          style: TextStyle(
            color: color,
            fontFamily: style?.fontFamily,
            fontSize: style?.fontSize,
            fontWeight: style?.fontWeight,
            height: style?.height,
            debugLabel: style?.debugLabel,
          ),
        );
}
