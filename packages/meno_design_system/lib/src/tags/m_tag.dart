import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget representing a tag with a title and customizable styling.
///
/// This widget displays a colored container with rounded corners and the
/// provided title inside.
class MTag extends StatelessWidget {
  /// Creates a new `MTag` widget.
  ///
  /// * `title`: The text displayed within the tag.
  /// * `style`: An optional style to apply to the title text.
  /// * `height`: The fixed height of the tag (default: 20.0).
  const MTag({required this.title, super.key, this.style, this.height = 20.0});

  /// The text displayed within the tag.
  final String title;

  /// An optional style to apply to the title text.
  final TextStyle? style;

  /// The fixed height of the tag.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Container(
      height: height.h,
      constraints: BoxConstraints(minHeight: height, maxHeight: height).r,
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm).r,
      alignment: Alignment.centerLeft,
      decoration: ShapeDecoration(
        color: colors.inActiveContainer,
        shape: RoundedRectangleBorder(borderRadius: Corners.xs.r),
      ),
      child: SizedBox(
        child: Center(
          child: MText.caption(
            title,
            color: colors.onInActiveContainer,
            style: style,
          ),
        ),
      ),
    );
  }
}
