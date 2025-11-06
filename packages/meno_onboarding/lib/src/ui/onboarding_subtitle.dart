import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingSubtitle extends StatelessWidget {
  const OnboardingSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 48.h,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30).r,
          child: MText.body(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            weight: MFontWeight.regular,
          ),
        ),
      ),
    );
  }
}
