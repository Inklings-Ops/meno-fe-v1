import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../infrastructure/onboarding_items.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: SizedBox(
        height: 8,
        child: Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            onboardingItems.length,
            (index) {
              final bool selected = currentIndex == index;

              return Container(
                height: selected ? 8 : 4,
                width: selected ? 8 : 4,
                decoration: BoxDecoration(
                  color: selected ? primaryColor : MColor.grey50,
                  shape: BoxShape.circle,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
