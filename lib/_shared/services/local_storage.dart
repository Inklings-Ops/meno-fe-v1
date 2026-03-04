import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocalStorage implements Disposable {
  LocalStorage(this._preferences);

  final SharedPreferences _preferences;

  final _controller = StreamController<String>.broadcast();

  /// Watch for changes on a specific key.
  ///
  /// Emits the current value immediately (startWith behavior),
  /// and then emits any subsequent updates.
  Stream<String?> watchKey(String key) async* {
    // A. Emit the current value immediately (Synchronous read)
    yield getString(key);

    // B. Delegate to the change stream for future updates
    yield* _controller.stream
        .where((eventKey) => eventKey == key) // Filter for this key
        .map((_) => getString(key)); // Fetch new value
  }

  Future<bool> setString(String key, String value) async {
    final result = await _preferences.setString(key, value);
    if (result) _controller.add(key);
    return result;
  }

  Future<bool> remove(String key) async {
    final result = await _preferences.remove(key);
    if (result) _controller.add(key);
    return result;
  }

  Future<bool> setList(String key, List<String> value) async {
    final result = await _preferences.setStringList(key, value);
    if (result) _controller.add(key);
    return result;
  }

  bool hasKey(String key) => _preferences.containsKey(key);

  String? getString(String key) => _preferences.getString(key);

  List<String>? getList(String key) => _preferences.getStringList(key);

  @override
  FutureOr<dynamic> onDispose() {
    _controller.close();
  }
}
