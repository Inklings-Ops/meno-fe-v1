import 'package:flutter/material.dart';

import 'm_core.dart';

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
  static const SizedBox verticalSpaceXXXLarge =
      SizedBox(height: MCore.xxxLarge);

  static const SizedBox horizontalSpaceMicro = SizedBox(width: MCore.micro);
  static const SizedBox horizontalSpaceSmall = SizedBox(width: MCore.small);
  static const SizedBox horizontalSpaceMedium = SizedBox(width: MCore.medium);
  static const SizedBox horizontalSpaceLarge = SizedBox(width: MCore.large);
  static const SizedBox horizontalSpaceXLarge = SizedBox(width: MCore.xLarge);
  static const SizedBox horizontalSpaceXXLarge = SizedBox(width: MCore.xxLarge);
  static const SizedBox horizontalSpaceXXXLarge =
      SizedBox(width: MCore.xxxLarge);
}

// extension MSizeX on num {
//   SizedBox get verticalSpace => SizedBox(height: toDouble());
//   SizedBox get horizontalSpace => SizedBox(width: toDouble());
// }
