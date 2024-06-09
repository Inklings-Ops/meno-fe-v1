import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';

class MHeader extends StatelessWidget {
  final String title;
  // final String? actionTitle;
  // final VoidCallback? action;
  final Widget? action;
  final bool showSideBorder;
  final EdgeInsetsGeometry? padding;

  const MHeader({
    super.key,
    required this.title,
    // this.actionTitle,
    // this.action,
    this.action,
    this.showSideBorder = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Container(
      color: colorScheme.background,
      height: 30,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showSideBorder) ...[
            Container(
              width: 3,
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: colorScheme.error,
            ),
            MSize.horizontalSpaceMicro,
          ],
          MText(title, style: MTextStyle.heading3Bold),
          const Spacer(),
          if (action != null) action!
          // if (actionTitle != null && action != null)
            // InkWell(
            //   onTap: action,
            //   child: MText(
            //     actionTitle!,
            //     color: colorScheme.onBackgroundVariant,
            //   ),
            // ),
        ],
      ),
    );
  }
}
