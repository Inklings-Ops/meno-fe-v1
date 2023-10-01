import 'package:flutter/material.dart';

class MCore {
  const MCore._();
  static const double micro = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 20.0;
  static const double xxLarge = 32.0;
  static const double circle = 555.0;
}

class MSize {
  const MSize._();

  static SizedBox verticalSpace(double height) => SizedBox(height: height);
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  static const SizedBox verticalSpaceMicro = SizedBox(height: MCore.micro);
  static const SizedBox verticalSpaceSmall = SizedBox(height: MCore.small);
  static const SizedBox verticalSpaceMedium = SizedBox(height: MCore.medium);
  static const SizedBox verticalSpaceLarge = SizedBox(height: MCore.large);
  static const SizedBox verticalSpaceXLarge = SizedBox(height: MCore.xLarge);
  static const SizedBox verticalSpaceXXLarge = SizedBox(height: MCore.xxLarge);

  static const SizedBox horizontalSpaceMicro = SizedBox(width: MCore.micro);
  static const SizedBox horizontalSpaceSmall = SizedBox(width: MCore.small);
  static const SizedBox horizontalSpaceMedium = SizedBox(width: MCore.medium);
  static const SizedBox horizontalSpaceLarge = SizedBox(width: MCore.large);
  static const SizedBox horizontalSpaceXLarge = SizedBox(width: MCore.xLarge);
  static const SizedBox horizontalSpaceXXLarge = SizedBox(width: MCore.xxLarge);
}

extension MSizeX on num {
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(height: toDouble());
}
