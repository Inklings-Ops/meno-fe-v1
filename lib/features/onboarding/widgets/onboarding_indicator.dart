import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    required this.currentIndex, required this.itemsLength, super.key,
  });
  final int currentIndex;
  final int itemsLength;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Center(
      child: SizedBox(
        height: 8,
        child: Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            itemsLength,
            (index) {
              final selected = currentIndex == index;
              final dimensions = selected ? 8.0 : 4.0;
              return Container(
                height: dimensions,
                width: dimensions,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? colors.primary : colors.outlineVariant3,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
