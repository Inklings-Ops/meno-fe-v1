import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget representing a header with a title, optional action, and styling
/// options.
class MHeader extends StatelessWidget {
  /// Creates a new `MHeader` widget.
  ///
  /// * `title`: The text displayed as the header title.
  /// * `action`: An optional widget to display on the right side of the header.
  /// * `showSideBorder`: Whether to display a side border (default: true).
  /// * `padding`: The padding around the header content (optional).
  /// * `addTopMargin`: Whether to add a top margin to the header
  /// (default: false).
  const MHeader({
    required this.title,
    super.key,
    this.action,
    this.showSideBorder = true,
    this.padding,
    this.addTopMargin = false,
  });

  /// The title of the header.
  final String title;

  /// An optional widget to display on the right side of the header.
  final Widget? action;

  /// Whether to display a side border.
  final bool showSideBorder;

  /// The padding around the header content.
  final EdgeInsets? padding;

  /// Whether to add a top margin to the header.
  final bool addTopMargin;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Container(
      color: colors.background,
      height: 30.h,
      margin: addTopMargin ? const EdgeInsets.only(top: 8).r : null,
      padding: padding?.r ?? const EdgeInsets.fromLTRB(16, 0, 16, 0).r,
      child: Row(
        children: [
          if (showSideBorder) ...[
            Container(
              width: 3.w,
              margin: const EdgeInsets.symmetric(vertical: 2).r,
              color: colors.error,
            ),
            Spaces.horizontalMicro,
          ],
          MText.heading3(
            title,
            color: colors.onBackground,
            weight: MFontWeight.bold,
          ),
          const Spacer(),
          if (action != null) action!,
        ],
      ),
    );
  }
}
