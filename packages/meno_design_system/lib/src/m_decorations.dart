import 'package:flutter/material.dart';

class MDecorations {
  MDecorations._();

  static const defaultBoxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 4),
      spreadRadius: 2,
    )
  ];

  static const micBoxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x4B360090),
      blurRadius: 8,
      offset: Offset(0, 5),
      spreadRadius: 1,
    ),
  ];

  static const cardShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 10,
      offset: Offset(0, 2),
      spreadRadius: 2,
    )
  ];
}
