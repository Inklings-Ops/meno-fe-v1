import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/m_keys.dart';

@Injectable()
class OnboardingLocalDatasource {
  final SharedPreferences _storage;

  OnboardingLocalDatasource({
    required SharedPreferences storage,
  }) : _storage = storage;

  bool get isOnboarded => _storage.containsKey(MKeys.onboardingKey);

  Future get completeOnboarding => _storage.setInt(MKeys.onboardingKey, 1);

  Future get clearCache => _storage.remove(MKeys.onboardingKey);
}
