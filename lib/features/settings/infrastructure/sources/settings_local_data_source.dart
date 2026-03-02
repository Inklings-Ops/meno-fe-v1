import 'dart:convert';

import 'package:meno/core/core.dart';
import 'package:meno/features/settings/infrastructure/dtos/user_settings_dto.dart';

class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._storage);

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
