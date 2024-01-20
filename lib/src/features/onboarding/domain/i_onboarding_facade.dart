/// An interface representing the onboarding facade.
///
/// This interface defines methods and properties related to the onboarding
/// process.
abstract class IOnboardingFacade {
  /// Clears the onboarding cache asynchronously.
  ///
  /// Implementations should perform the necessary tasks to clear any cached
  /// data related to onboarding.
  Future<void> get clearCache;

  /// Completes the onboarding process asynchronously.
  ///
  /// Implementations should perform the necessary tasks to mark the onboarding
  /// as complete. This may include updating user preferences or performing
  /// other onboarding-related actions.
  Future<void> get completeOnboarding;

  /// Checks if the user has completed the onboarding process.
  ///
  /// Returns `true` if the user has completed onboarding; otherwise,
  /// returns `false`.
  bool get isOnboarded;
}
