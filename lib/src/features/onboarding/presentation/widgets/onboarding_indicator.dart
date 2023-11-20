import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../infrastructure/onboarding_items.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  const OnboardingIndicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Center(
      child: SizedBox(
        height: 8.h,
        child: Wrap(
          spacing: 4.w,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            onboardingItems.length,
            (index) {
              final bool selected = currentIndex == index;
              final double dimensions = selected ? 8.r : 4.r;
              return Container(
                height: dimensions,
                width: dimensions,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant3,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
