import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A customizable divider with spacing control.
///
/// This widget provides a horizontal divider with optional spacing above and
/// below.
///
/// You can also control the indent and end indent of the divider.
class MDivider extends StatelessWidget {
  /// Creates a new `MDivider` widget.
  ///
  /// * `topSpace`: The vertical space above the divider.
  /// * `bottomSpace`: The vertical space below the divider.
  /// * `start`: The horizontal indent of the divider.
  /// * `end`: The horizontal end indent of the divider.
  const MDivider({
    super.key,
    this.topSpace,
    this.bottomSpace,
    this.start,
    this.end,
  });

  /// The vertical space above the divider.
  final double? topSpace;

  /// The vertical space below the divider.
  final double? bottomSpace;

  /// The horizontal indent of the divider.
  final double? start;

  /// The horizontal end indent of the divider.
  final double? end;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      (topSpace ?? 0).verticalSpace,
      Divider(endIndent: end?.w, indent: start?.w, height: 1.h),
      (bottomSpace ?? 0).verticalSpace,
    ],
  );
}
