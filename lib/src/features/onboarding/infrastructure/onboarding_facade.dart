import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/m_keys.dart';
import '../domain/i_onboarding_facade.dart';

/// Implementation of [IOnboardingFacade] using SharedPreferences for
/// onboarding-related tasks.
@Injectable(as: IOnboardingFacade)
class OnboardingFacade implements IOnboardingFacade {
  final SharedPreferences _storage;

  /// Constructs an [OnboardingFacade] with the provided [storage].
  OnboardingFacade({
    required SharedPreferences storage,
  }) : _storage = storage;

  /// Clears the onboarding cache stored in SharedPreferences.
  ///
  /// This method removes the onboarding key from SharedPreferences.
  @override
  Future<void> get clearCache => _storage.remove(MKeys.onboardingKey);

  /// Marks the onboarding as complete in SharedPreferences.
  ///
  /// This method sets the onboarding key to 1 in SharedPreferences.
  @override
  Future<void> get completeOnboarding {
    return _storage.setInt(MKeys.onboardingKey, 1);
  }

  /// Checks if the user has completed the onboarding process based on the
  /// presence of the onboarding key in SharedPreferences.
  ///
  /// Returns `true` if the onboarding key is present; otherwise, returns
  /// `false`.
  @override
  bool get isOnboarded => _storage.containsKey(MKeys.onboardingKey);
}
