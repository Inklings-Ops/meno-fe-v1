import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';

class ExpandButton extends StatelessWidget {
  final VoidCallback? onTap;
  const ExpandButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        width: 94,
        padding: const EdgeInsets.symmetric(
          horizontal: MCore.medium,
          vertical: MCore.small,
        ),
        decoration: BoxDecoration(
          color: colorScheme.outlineVariant2,
          borderRadius: BorderRadius.circular(MCore.circle),
        ),
        child: Row(
          children: [
            Icon(
              MIcons.expand_01,
              size: 16,
              color: colorScheme.onDisabledContainer,
            ),
            MSize.horizontalSpaceSmall,
            MText(
              "Expand",
              style: MTextStyle.captionMedium,
              color: colorScheme.onDisabledContainer,
            ),
          ],
        ),
      ),
    );
  }
}
