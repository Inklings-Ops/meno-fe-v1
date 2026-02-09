import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

final class LocalStorage {
  const LocalStorage(this._preferences);

  final SharedPreferences _preferences;

  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  String? getString(String key) => _preferences.getString(key);

  bool hasKey(String key) => _preferences.containsKey(key);

  Future<bool> setList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  List<String>? getList(String key) => _preferences.getStringList(key);

  Future<bool> remove(String key) => _preferences.remove(key);
}
