import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MHeader extends StatelessWidget {
  const MHeader({
    super.key,
    required this.title,
    this.action,
    this.showSideBorder = true,
    this.padding,
  });
  final String title;
  final Widget? action;
  final bool showSideBorder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Container(
      color: colors.background,
      height: 30.toScale,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 0).radius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showSideBorder) ...[
            Container(
              width: 3.toScale,
              margin: const EdgeInsets.symmetric(vertical: 2).radius,
              color: colors.error,
            ),
            $styles.spaces.horizontalMicro,
          ],
          MText(
            title,
            style: $styles.text.heading3Bold,
            color: colors.onBackground,
          ),
          const Spacer(),
          if (action != null) action!
        ],
      ),
    );
  }
}
