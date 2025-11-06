import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: 44,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            MText(
              text,
              style: MTextTheme.of(context).heading1Bold,
              textAlign: TextAlign.center,
            ),
            Positioned(
              bottom: 0,
              height: 8,
              width: constraints.maxWidth,
              child: const ColoredBox(color: MColor.decorativeYellow75),
            ),
          ],
        ),
      ),
    ),
  );
}
