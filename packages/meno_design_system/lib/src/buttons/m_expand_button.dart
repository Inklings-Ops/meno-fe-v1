import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A button widget that represents an "Expand" action.
///
/// This button displays an icon and text, and can be tapped to trigger a
/// callback.
///
/// Example usage:
/// ```dart
/// ExpandButton(
///   onTap: () {
///     // Handle the expand action.
///   },
/// );
/// ```
class ExpandButton extends StatelessWidget {
  /// Creates an instance of [ExpandButton].
  ///
  /// Parameters:
  /// - [key]: An optional key to identify the widget.
  /// - [onTap]: An optional callback function to be invoked when the button
  /// is tapped.
  const ExpandButton({super.key, this.onTap});

  /// The callback function to be invoked when the button is tapped.
  ///
  /// If not provided, the button will not perform any action when tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: Corners.circle,
      child: Container(
        height: 34.h,
        width: 94.w,
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.sm,
        ).r,
        decoration: BoxDecoration(
          color: colors.inActiveContainer,
          borderRadius: Corners.circle.r,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              MIcons.expand_01,
              size: 16.sp,
              color: colors.onInActiveContainer,
            ),
            MText.caption('Expand', color: colors.onInActiveContainer),
          ],
        ),
      ),
    );
  }
}
