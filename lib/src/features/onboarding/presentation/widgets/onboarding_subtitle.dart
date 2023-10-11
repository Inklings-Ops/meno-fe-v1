import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingSubtitle extends StatelessWidget {
  final String text;
  const OnboardingSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34.0),
        child: MText(
          text,
          style: MTextStyle.bodyRegular,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}
