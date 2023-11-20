import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';

import '../../../shared/m_keys.dart';

@Injectable()
class OnboardingLocalDatasource {
  final SecureStorageService _storage;

  OnboardingLocalDatasource({
    required SecureStorageService storage,
  }) : _storage = storage;

  Future<bool> isOnboarded() => _storage.hasKey(MKeys.onboardingKey);

  Future<void> onboardingCompleted() =>
      _storage.write(MKeys.onboardingKey, value: "1");

  Future<void> clear() => _storage.delete(MKeys.onboardingKey);
}
