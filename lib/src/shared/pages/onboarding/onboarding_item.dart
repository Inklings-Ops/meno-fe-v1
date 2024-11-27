
import 'package:meno_fe_v1/meno.dart';

final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    title: 'Broadcast',
    subtitle:
        'to your audience and share links for them to join your broadcast.',
    imagePath: Assets.images.onboarding1.keyName,
  ),
  OnboardingItem(
    title: 'Stream',
    subtitle:
        'broadcasts from individuals or ministries you are interested in.',
    imagePath: Assets.images.onboarding2.keyName,
  ),
  OnboardingItem(
    title: 'Live Bible',
    subtitle: 'as you stream, have an immersive experience.',
    imagePath: Assets.images.onboarding3.keyName,
  ),
  OnboardingItem(
    title: 'Take Notes',
    subtitle: 'as you stream, take note of things that stand out to you.',
    imagePath: Assets.images.onboarding4.keyName,
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
