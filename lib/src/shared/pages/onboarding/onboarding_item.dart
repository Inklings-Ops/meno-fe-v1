import 'package:meno_fe_v1/gen/assets.gen.dart';

final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    title: 'Broadcast',
    subtitle:
        'to your audience and share links for them to join your broadcast.',
    imagePath: Assets.images.onboarding1.path,
  ),
  OnboardingItem(
    title: 'Stream',
    subtitle:
        'broadcasts from individuals or ministries you are interested in.',
    imagePath: Assets.images.onboarding2.path,
  ),
  OnboardingItem(
    title: 'Live Bible',
    subtitle: 'as you stream, have an immersive experience.',
    imagePath: Assets.images.onboarding3.path,
  ),
  OnboardingItem(
    title: 'Take Notes',
    subtitle: 'as you stream, take note of things that stand out to you.',
    imagePath: Assets.images.onboarding4.path,
  ),
];

class OnboardingItem {
  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
  final String title;
  final String subtitle;
  final String imagePath;
}
