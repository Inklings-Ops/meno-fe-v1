import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/m_keys.dart';

@Injectable()
class OnboardingLocalDatasource {
  final SharedPreferences _pref;

  OnboardingLocalDatasource({
    required SharedPreferences storage,
  }) : _pref = storage;

  bool isOnboarded() => _pref.containsKey(MKeys.onboardingKey);

  Future<void> onboardingCompleted() => _pref.setInt(MKeys.onboardingKey, 1);

  Future<void> clear() => _pref.remove(MKeys.onboardingKey);
}
