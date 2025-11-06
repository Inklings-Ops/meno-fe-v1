import 'package:disco/disco.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meno_domain/meno_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A DI provider to supply a [SharedPreferences] instance.
final sharedPreferencesProvider = Provider.withArgument(
  (context, SharedPreferences prefs) => prefs,
);

/// A DI provider to supply a [FlutterSecureStorage] instance.
final secureStorageProvider = Provider.withArgument(
  (context, FlutterSecureStorage secureStorage) => secureStorage,
);

// The concrete implementation of the [LocalStorage] contract.
///
/// This class uses [SharedPreferences] for non-secure, synchronous storage
/// and [FlutterSecureStorage] for secure, asynchronous storage, fulfilling
/// the contract defined by the [LocalStorage] abstract class.
final class LocalStorageImpl implements LocalStorage {
  /// Creates an instance of [LocalStorageImpl].
  ///
  /// Requires instances of [SharedPreferences] and [FlutterSecureStorage]
  /// to be provided.
  const LocalStorageImpl({
    required SharedPreferences preferences,
    required FlutterSecureStorage secureStorage,
  }) : _preferences = preferences,
       _secureStorage = secureStorage;

  final SharedPreferences _preferences;
  final FlutterSecureStorage _secureStorage;

  /// A DI provider to construct an instance of [LocalStorageImpl].
  ///
  /// It reads the required [SharedPreferences] and [FlutterSecureStorage]
  /// instances from the DI container to create the object.
  static final provider = Provider<LocalStorage>(
    (context) => LocalStorageImpl(
      preferences: sharedPreferencesProvider.of(context),
      secureStorage: secureStorageProvider.of(context),
    ),
  );

  @override
  Future<void> delete(String key, {bool secure = false}) {
    if (!secure) return _preferences.remove(key);

    try {
      return _secureStorage.delete(key: key);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> deleteAll({bool secure = false}) {
    if (!secure) return _preferences.clear();

    try {
      return _secureStorage.deleteAll();
    } on Exception {
      rethrow;
    }
  }

  @override
  bool hasKey(String key) => _preferences.containsKey(key);

  @override
  Future<bool> hasKeyAsync(String key) {
    try {
      return _secureStorage.containsKey(key: key);
    } on Exception {
      rethrow;
    }
  }

  @override
  Object? read(String key) => _preferences.get(key);

  @override
  Future<String?> readAsync(String key) {
    try {
      return _secureStorage.read(key: key);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> write(String key, {required String value, bool secure = false}) {
    if (!secure) return _preferences.setString(key, value);

    try {
      return _secureStorage.write(key: key, value: value);
    } on Exception {
      rethrow;
    }
  }
}
