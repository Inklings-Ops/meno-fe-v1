import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingTitle extends StatelessWidget {
  final String text;
  const OnboardingTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: 44,
            child: Stack(
              children: [
                MText(
                  text,
                  style: MTextStyle.heading1Bold,
                  textAlign: TextAlign.center,
                ),
                Positioned(
                  bottom: 0.h,
                  height: 8,
                  width: constraints.maxWidth.w,
                  child: const ColoredBox(color: MColor.decorativeYellow75),
                ),
              ],
            ),
          ),
        ),
      );
}
