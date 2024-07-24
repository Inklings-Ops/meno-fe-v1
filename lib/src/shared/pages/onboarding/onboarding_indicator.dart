import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.itemsLength,
  });
  final int currentIndex;
  final int itemsLength;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Center(
      child: SizedBox(
        height: 8.toScale,
        child: Wrap(
          spacing: 4.toScale,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            itemsLength,
            (index) {
              final selected = currentIndex == index;
              final dimensions = selected ? 8.toScale : 4.toScale;
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
