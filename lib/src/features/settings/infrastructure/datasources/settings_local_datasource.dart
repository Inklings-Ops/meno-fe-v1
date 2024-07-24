import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class SettingsLocalDatasource {
  SettingsLocalDatasource({
    required SharedPreferences preferences,
  }) : _preferences = preferences;
  final SharedPreferences _preferences;

  Future<void> get clearCache {
    return Future.wait([
      _preferences.remove(MKeys.settings),
      _preferences.remove(MKeys.onboardingKey),
    ]);
  }

  Future<void> get completeOnboarding {
    return _preferences.setInt(MKeys.onboardingKey, 1);
  }

  bool get isOnboard => _preferences.containsKey(MKeys.onboardingKey);
}
