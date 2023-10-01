import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/onboarding/domain/onboard.dart';
import 'package:meno_fe_v1/features/onboarding/presentation/widgets/onboarding_subtitle.dart';
import 'package:meno_fe_v1/features/onboarding/presentation/widgets/onboarding_title.dart';

class OnboardingBody extends StatelessWidget {
  final Onboard onboard;
  const OnboardingBody({super.key, required this.onboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(onboard.imagePath, height: 240, width: 240),
        24.verticalSpace,
        OnboardingTitle(onboard.title),
        MSize.verticalSpaceXLarge,
        OnboardingSubtitle(onboard.subtitle),
      ],
    );
  }
}
