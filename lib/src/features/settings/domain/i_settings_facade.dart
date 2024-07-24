abstract class ISettingsFacade {
  bool get isOnboarded;
  Future<void> get clearCache;
  Future<void> get completeOnboarding;
}
