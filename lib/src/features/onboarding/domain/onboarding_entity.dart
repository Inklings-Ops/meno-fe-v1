/// Represents an entity containing information for onboarding content.
class OnboardingEntity {
  /// The title of the onboarding entity.
  final String title;

  /// The subtitle of the onboarding entity.
  final String subtitle;

  /// The file path to the image associated with the onboarding entity.
  final String imagePath;

  /// Constructs an [OnboardingEntity] with the provided [title],
  /// [subtitle], and [imagePath].
  OnboardingEntity({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}
