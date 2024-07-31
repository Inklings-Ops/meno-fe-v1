import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'onboarding.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody(this.item, {super.key});
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    const imageDimension = 240.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Image.asset(
            item.imagePath,
            height: imageDimension,
            width: imageDimension,
          ),
          Spaces.verticalXLarge,
          OnboardingTitle(item.title),
          Spaces.verticalLarge,
          Flexible(child: OnboardingSubtitle(item.subtitle)),
        ],
      ),
    );
  }
}
