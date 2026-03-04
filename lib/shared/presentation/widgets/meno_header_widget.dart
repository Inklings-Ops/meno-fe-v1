import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoHeaderWidget extends StatelessWidget {
  const MenoHeaderWidget({
    required this.title,
    super.key,
    this.action,
    this.showSideBorder = true,
    this.padding,
    this.addTopMargin = false,
  });

  /// The title of the header.
  final Widget title;

  /// An optional widget to display on the right side of the header.
  final Widget? action;

  /// Whether to display a side border.
  final bool showSideBorder;

  /// The padding around the header content.
  final EdgeInsetsGeometry? padding;

  /// Whether to add a top margin to the header.
  final bool addTopMargin;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      height: 30,
      margin: addTopMargin ? const .only(top: 8) : null,
      padding: padding ?? const .fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          if (showSideBorder) ...[
            Container(
              width: 3,
              margin: const .symmetric(vertical: 2),
              color: colors.error,
            ),
            Spaces.horizontalMicro,
          ],
          DefaultTextStyle(
            style: textTheme.heading3Bold.copyWith(color: colors.onBackground),
            child: title,
          ),
          const Spacer(),
          if (action != null) action!,
        ],
      ),
    );
  }
}
