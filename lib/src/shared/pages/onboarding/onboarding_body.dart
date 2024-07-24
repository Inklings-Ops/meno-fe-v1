import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'onboarding.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody(this.item, {super.key});
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final imageDimension = 240.toScale;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
      child: Column(
        children: [
          Image.asset(
            item.imagePath,
            height: imageDimension,
            width: imageDimension,
          ),
          24.vSpace,
          OnboardingTitle(item.title),
          $styles.spaces.verticalLarge,
          Flexible(child: OnboardingSubtitle(item.subtitle)),
        ],
      ),
    );
  }
}
