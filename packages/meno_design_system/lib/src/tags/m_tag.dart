import 'package:flutter/material.dart';
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
  const MTag({
    required this.title,
    super.key,
    this.style,
    this.height = 20.0,
  });

  /// The text displayed within the tag.
  final String title;

  /// An optional style to apply to the title text.
  final TextStyle? style;

  /// The fixed height of the tag.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Container(
      height: height,
      constraints: BoxConstraints(minHeight: height, maxHeight: height),
      padding: const EdgeInsets.symmetric(horizontal: Insets.small),
      alignment: Alignment.centerLeft,
      decoration: ShapeDecoration(
        color: colors.inActiveContainer,
        shape: const RoundedRectangleBorder(borderRadius: Corners.micro),
      ),
      child: SizedBox(
        child: Center(
          child: MText(
            title,
            style: style ?? textTheme.captionMedium,
            color: colors.onInActiveContainer,
          ),
        ),
      ),
    );
  }
}
