import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingTitle extends StatelessWidget {
  final String text;
  const OnboardingTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                bottom: 0,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: 8,
                  child: const ColoredBox(
                    color: MColor.decorativeYellow75,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
