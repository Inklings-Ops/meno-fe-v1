import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_onboarding/src/domain/domain.dart';
import 'package:meno_onboarding/src/ui/ui.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody(this.item, {super.key});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final imageDimension = 240.0.r;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).r,
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
