import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../domain/onboard.dart';
import 'onboarding_subtitle.dart';
import 'onboarding_title.dart';

class OnboardingBody extends StatelessWidget {
  final Onboard onboard;
  const OnboardingBody(this.onboard, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
        child: Column(
          children: [
            Image.asset(onboard.imagePath, height: 240.r, width: 240.r),
            24.verticalSpace,
            OnboardingTitle(onboard.title),
            MCore.large.verticalSpace,
            Flexible(child: OnboardingSubtitle(onboard.subtitle)),
          ],
        ),
      );
}
