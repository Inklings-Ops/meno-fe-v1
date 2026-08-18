import 'dart:convert';

import 'package:meno/_core/keys/storage_keys.dart';
import 'package:meno/_shared/services/local_storage.dart';
import 'package:meno/features/settings/model/_model.dart';

class SettingsLocalService {
  const SettingsLocalService(this._storage);

  final LocalStorage _storage;

  UserSettingsDto? getUserSettings(String userId) {
    final key = StorageKeys.userSettingsCache(userId);
    final jsonStr = _storage.getString(key);
    if (jsonStr == null) return null;
    return UserSettingsDto.fromJson(jsonDecode(jsonStr));
  }

  Future<void> saveUserSettings(String userId, UserSettingsDto settings) {
    final key = StorageKeys.userSettingsCache(userId);
    final jsonStr = jsonEncode(settings.toJson());
    return _storage.setString(key, jsonStr);
  }
}
