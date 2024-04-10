import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/m_keys.dart';

/// A local data source for managing onboarding-related data using SharedPreferences.
@Injectable()
class OnboardingLocalDatasource {
  final SharedPreferences _storage;

  /// Constructs an [OnboardingLocalDatasource] with the provided [storage].
  OnboardingLocalDatasource({
    required SharedPreferences storage,
  }) : _storage = storage;

  /// Clears the onboarding cache stored in SharedPreferences.
  ///
  /// This method removes the onboarding key from SharedPreferences.
  Future<void> get clearCache => _storage.remove(MKeys.onboardingKey);

  /// Marks the onboarding as complete in SharedPreferences.
  ///
  /// This method sets the onboarding key to 1 in SharedPreferences.
  Future<void> get completeOnboarding =>
      _storage.setInt(MKeys.onboardingKey, 1);

  /// Checks if the user has completed the onboarding process based on the
  /// presence of the onboarding key in SharedPreferences.
  ///
  /// Returns `true` if the onboarding key is present; otherwise, returns
  /// `false`.
  bool get isOnboarded => _storage.containsKey(MKeys.onboardingKey);
}
