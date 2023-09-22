import 'package:flutter/material.dart';

class MDimensions {
  MDimensions._();

  static const double btnMicro = 24.0;
  static const double btnSmall = 32.0;
  static const double btnMedium = 40.0;
  static const double btnLarge = 48.0;

  static const smallBorderRadius = BorderRadius.all(Radius.circular(4));
  static const mediumBorderRadius = BorderRadius.all(Radius.circular(8));
  static const largeBorderRadius = BorderRadius.all(Radius.circular(12));

  static const btnMicroPadding = EdgeInsets.all(8);
  static const btnSmallPadding = EdgeInsets.fromLTRB(16, 8, 16, 8);
  static const btnMediumPadding = EdgeInsets.fromLTRB(16, 8, 16, 8);
  static const btnLargePadding = EdgeInsets.fromLTRB(20, 8, 20, 8);
  static const textFieldPadding = EdgeInsets.all(12);
  static const maxLengthIndictorPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const otpPadding = EdgeInsets.all(24);


  static const otpConstraints = BoxConstraints(maxHeight: 88, maxWidth: 88);
  
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
