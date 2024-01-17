import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CountDownDialog extends StatelessWidget {
  const CountDownDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return SizedBox(
      width: 152.w,
      height: 196.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MText(
            'Going Live in...',
            style: MTextStyle.heading2Medium,
            color: colorScheme.onPrimary,
          ),
          MCore.large.verticalSpace,
          CircleAvatar(
            radius: 72.r,
            backgroundColor: colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(MCore.small).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MText(
                    '3',
                    style: MTextStyle.countDown,
                    color: colorScheme.onPrimary,
                  ),
                  MCore.large.verticalSpace,
                  MText(
                    'Skip',
                    style: MTextStyle.bodyMedium,
                    color: colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
