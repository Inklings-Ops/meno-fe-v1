import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingSubtitle extends StatelessWidget {
  const OnboardingSubtitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Center(
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: MText(
          text,
          style: textTheme.bodyRegular,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}
