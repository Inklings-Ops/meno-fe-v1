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

  final Widget title;
  final Widget? action;
  final bool showSideBorder;
  final EdgeInsetsGeometry? padding;
  final bool addTopMargin;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      height: 30,
      margin: addTopMargin ? const EdgeInsets.only(top: 8) : null,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showSideBorder) ...[
            Container(
              width: 3,
              margin: const EdgeInsets.symmetric(vertical: 2),
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
