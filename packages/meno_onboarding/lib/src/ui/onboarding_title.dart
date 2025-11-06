import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 44.h,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              MText.heading1(
                text,
                textAlign: TextAlign.center,
                weight: MFontWeight.bold,
              ),
              Positioned(
                bottom: 0.h,
                height: 8.h,
                width: constraints.maxWidth,
                child: const ColoredBox(color: MColor.decorativeYellow75),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
