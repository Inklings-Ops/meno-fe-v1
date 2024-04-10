import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ExpandButton extends StatelessWidget {
  final VoidCallback? onTap;
  const ExpandButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        width: 94.w,
        padding: const EdgeInsets.symmetric(
          horizontal: MCore.medium,
          vertical: MCore.small,
        ),
        decoration: BoxDecoration(
          color: colorScheme.outlineVariant2,
          borderRadius: BorderRadius.circular(MCore.circle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              MIcons.expand_01,
              size: 16.r,
              color: colorScheme.onDisabledContainer,
            ),
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
