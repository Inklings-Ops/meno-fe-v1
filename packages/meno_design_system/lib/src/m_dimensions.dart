import 'package:flutter/material.dart';

class MDimensions {
  MDimensions._();

  static const double micro = 24.0;
  static const double small = 32.0;
  static const double medium = 40.0;
  static const double large = 48.0;

  static const smallBorderRadius = BorderRadius.all(Radius.circular(4));
  static const mediumBorderRadius = BorderRadius.all(Radius.circular(8));
  static const largeBorderRadius = BorderRadius.all(Radius.circular(12));

  static const defaultBoxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 4),
      spreadRadius: 2,
    )
  ];

  static const verticalSpace8 = SizedBox(height: 8);
}
