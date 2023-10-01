import 'dart:convert';

import 'package:meno_fe_v1/services/secure_storage_service.dart';
import 'package:meno_fe_v1/shared/m_keys.dart';

class OnboardingLocalDatasource {
  final SecureStorageService _storage;

  OnboardingLocalDatasource({
    required SecureStorageService storage,
  }) : _storage = storage;

  Future<bool> isOnboarded() async =>
      await _storage.hasKey(MKeys.onboardingKey);

  Future<void> setOnboarding(String key, {required bool value}) async {
    return await _storage.write(key, value: jsonEncode(value));
  }
}
