import 'package:meno_design_system/meno_design_system.dart';

import '../domain/onboard.dart';

final List<Onboard> onboardingItems = [
  Onboard(
    title: "Broadcast",
    subtitle:
        "to your audience and share links for them to join your broadcast.",
    imagePath: Assets.images.onboarding1.path,
  ),
  Onboard(
    title: "Stream",
    subtitle:
        "broadcasts from individuals or ministries you are interested in.",
    imagePath: Assets.images.onboarding2.path,
  ),
  Onboard(
    title: "Live Bible",
    subtitle: "as you stream, have an immersive experience.",
    imagePath: Assets.images.onboarding3.path,
  ),
  Onboard(
    title: "Take Notes",
    subtitle: "as you stream, take note of things that stand out to you.",
    imagePath: Assets.images.onboarding4.path,
  ),
];
