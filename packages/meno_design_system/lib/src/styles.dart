import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class containing predefined spacing values for UI components.
@immutable
class Insets {
  const Insets._();

  /// Micro spacing (4 units).
  static const double xs = 4;

  /// Small spacing (8 units).
  static const double sm = 8;

  /// Medium spacing (12 units).
  static const double md = 12;

  /// Large spacing (16 units).
  static const double lg = 16;

  /// Extra-large spacing (24 units).
  static const double xl = 24;

  /// Extra-extra-large spacing (32 units).
  static const double xxl = 32;

  /// Extra-extra-extra-large spacing (48 units).
  static const double xxxl = 48;

  /// Circular spacing (555 units, typically used for full circles).
  static const double circle = 555;
}

/// A class containing predefined corner radius values for UI components.
@immutable
class Corners {
  const Corners._();

  /// Micro corner radius (4 units).
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));

  /// Small corner radius (8 units).
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));

  /// Medium corner radius (12 units).
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));

  /// Large corner radius (16 units).
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));

  /// Extra-large corner radius (24 units).
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));

  /// Extra-extra-large corner radius (32 units).
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(32));

  /// Extra-extra-extra-large corner radius (48 units).
  static const BorderRadius xxxl = BorderRadius.all(Radius.circular(48));

  /// Circular corner radius (555 units, typically used for full circles).
  static const BorderRadius circle = BorderRadius.all(Radius.circular(555));
}

/// A class containing predefined shadow values for UI components.
@immutable
class Shadows {
  const Shadows._();

  /// Soft shadow.
  static final soft = [
    BoxShadow(
      color: const Color(0x0C000000),
      offset: const Offset(0, 2),
      blurRadius: _blurRadius,
      spreadRadius: _spreadRadius,
    ),
  ];

  /// Medium shadow.
  static final medium = [
    BoxShadow(
      color: const Color(0x14000000),
      offset: const Offset(0, 6),
      blurRadius: _blurRadius,
      spreadRadius: 4,
    ),
  ];

  /// Strong shadow.
  static final strong = [
    BoxShadow(
      color: const Color(0x14000000),
      offset: const Offset(0, 8),
      blurRadius: _blurRadius,
      spreadRadius: _spreadRadius,
    ),
    BoxShadow(
      color: const Color(0x14000000),
      offset: const Offset(0, -1),
      blurRadius: 12.r,
    ),
  ];

  /// Micro shadow.
  static final mic = [
    BoxShadow(
      color: const Color(0x4B360090),
      blurRadius: 8.r,
      offset: const Offset(0, 5),
      spreadRadius: 1.r,
    ),
  ];

  static final double _blurRadius = 10.r;
  static final double _spreadRadius = 2.r;
}

/// A class containing predefined SizedBox widgets for common spacing values.
@immutable
class Spaces {
  const Spaces._();

  // Horizontal Spaces
  /// A SizedBox with a width of 4 logical pixels.
  static final SizedBox horizontalMicro = 4.horizontalSpace;

  /// A SizedBox with a width of 8 logical pixels.
  static final SizedBox horizontalSmall = 8.horizontalSpace;

  /// A SizedBox with a width of 12 logical pixels.
  static final SizedBox horizontalMedium = 12.horizontalSpace;

  /// A SizedBox with a width of 16 logical pixels.
  static final SizedBox horizontalLarge = 16.horizontalSpace;

  /// A SizedBox with a width of 24 logical pixels.
  static final SizedBox horizontalXLarge = 24.horizontalSpace;

  /// A SizedBox with a width of 32 logical pixels.
  static final SizedBox horizontalXXLarge = 32.horizontalSpace;

  /// A SizedBox with a width of 48 logical pixels.
  static final SizedBox horizontalXXXLarge = 48.horizontalSpace;

  // Vertical Spaces
  /// A SizedBox with a height of 4 logical pixels.
  static final SizedBox verticalMicro = 4.verticalSpace;

  /// A SizedBox with a height of 8 logical pixels.
  static final SizedBox verticalSmall = 8.verticalSpace;

  /// A SizedBox with a height of 12 logical pixels.
  static final SizedBox verticalMedium = 12.verticalSpace;

  /// A SizedBox with a height of 16 logical pixels.
  static final SizedBox verticalLarge = 16.verticalSpace;

  /// A SizedBox with a height of 24 logical pixels.
  static final SizedBox verticalXLarge = 24.verticalSpace;

  /// A SizedBox with a height of 32 logical pixels.
  static final SizedBox verticalXXLarge = 32.verticalSpace;

  /// A SizedBox with a height of 48 logical pixels.
  static final SizedBox verticalXXXLarge = 48.verticalSpace;
}

/// A class containing predefined sizes for toolbars.
@immutable
class ToolBarHeights {
  /// Height of the home toolbar.
  static final Size home = Size.fromHeight(64.h);

  /// Height of the primary toolbar.
  static final Size primary = Size.fromHeight(120.h);

  /// Height of the secondary toolbar.
  static final Size secondary = Size.fromHeight(56.h);
}
