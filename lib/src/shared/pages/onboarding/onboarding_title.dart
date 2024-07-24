import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingTitle extends StatelessWidget {
  final String text;
  const OnboardingTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          height: 44.toScale,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                MText(
                  text,
                  style: $styles.text.heading1Bold,
                  textAlign: TextAlign.center,
                ),
                Positioned(
                  bottom: 0,
                  height: 8.toScale,
                  width: constraints.maxWidth.toScale,
                  child: const ColoredBox(color: MColor.decorativeYellow75),
                ),
              ],
            ),
          ),
        ),
      );
}
