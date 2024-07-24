import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ExpandButton extends StatelessWidget {
  const ExpandButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.toScale,
        width: 94.toScale,
        padding: EdgeInsets.symmetric(
          horizontal: $styles.insets.medium,
          vertical: $styles.insets.small,
        ),
        decoration: BoxDecoration(
          color: colors.inActiveContainer,
          borderRadius: $styles.radius.circle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              MIcons.expand_01,
              size: 16.toScale,
              color: colors.onInActiveContainer,
            ),
            MText(
              "Expand",
              style: $styles.text.captionMedium,
              color: colors.onInActiveContainer,
            ),
          ],
        ),
      ),
    );
  }
}
