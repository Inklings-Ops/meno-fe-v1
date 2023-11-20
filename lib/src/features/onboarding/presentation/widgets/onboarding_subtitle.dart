import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingSubtitle extends StatelessWidget {
  final String text;
  const OnboardingSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30).r,
          constraints: const BoxConstraints(maxWidth: 343, maxHeight: 48).r,
          child: MText(
            text,
            style: MTextStyle.bodyRegular,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      );
}
