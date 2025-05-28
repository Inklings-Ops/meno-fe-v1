import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/config/config.dart' show AuthStorageKeys;
import 'package:meno_fe_v1/src/features/auth/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:rxdart/rxdart.dart';

/// A local data source for authentication.
@injectable
class AuthLocalDatasource {
  /// Creates a new `AuthLocalDatasource` object.
  AuthLocalDatasource({required SecureStorageService storage})
      : _storage = storage {
    initialize();
  }

  /// The secure storage service.
  final SecureStorageService _storage;

  final Map<String, UserCredentialDto> _cachedAccounts = {};

  final _currentAccSubject = BehaviorSubject<UserCredentialDto?>.seeded(null);
  final _allAccSub = BehaviorSubject<Map<String, UserCredentialDto>>.seeded({});

  Stream<UserCredentialDto?> get authStateChanges {
    return _currentAccSubject.stream.asBroadcastStream();
  }

  Stream<Map<String, UserCredentialDto>> get allAccountsStream {
    return _allAccSub.stream.asBroadcastStream();
  }

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    try {
      await getAllAccounts().then((allAccounts) async {
        _allAccSub.add(allAccounts);

        final currentAccount = await getCurrentAccount();
        _currentAccSubject.add(currentAccount);
      });
    } on Exception {
      _currentAccSubject.add(null);
    }
  }

  Future<void> switchAccount(UserCredentialDto credentialDto) async {
    final userId = credentialDto.user.id;
    final token = credentialDto.token;

    try {
      // Store the user's id
      await _storage.write(AuthStorageKeys.currentUserId, value: userId);

      // Store the user's authentication token
      await _storage.write(AuthStorageKeys.currentUserToken, value: token);

      _currentAccSubject.add(credentialDto);
      return;
    } on Exception {
      rethrow;
    }
  }

  Future<void> addAccount(
    UserCredentialDto credential, {
    bool rememberMe = false,
  }) async {
    final userId = credential.user.id;
    final token = credential.token;
    try {
      // Store the user's id
      await _storage.write(AuthStorageKeys.currentUserId, value: userId);
      log('User ID saved locally: $userId');

      // Store the user's authentication token
      await _storage.write(AuthStorageKeys.currentUserToken, value: token);
      log('User token saved locally: $token');

      if (rememberMe) {
        // Store the current user's data for without token for easy login
        final userData = jsonEncode(credential.user.stripped);
        await _storage.write(AuthStorageKeys.rememberedUser, value: userData);
      }

      // Store a stripped version of the user's credential using the user's id
      _cachedAccounts[userId] = credential.stripped;
      await _saveAccountsMap(_cachedAccounts);
      _currentAccSubject.add(credential);
    } on Exception catch (e) {
      log('Error on adding new account: $e');
      rethrow;
    }
  }

  Future<void> clearAllAccounts() async {
    _currentAccSubject.add(null);
    _cachedAccounts.clear();
    try {
      await _storage.delete(AuthStorageKeys.allAccounts);
      await _storage.delete(AuthStorageKeys.currentUserId);
      await _storage.delete(AuthStorageKeys.currentUserToken);
      await _storage.delete(AuthStorageKeys.rememberedUser);
    } on Exception {
      rethrow;
    }
  }

  Future<UserCredentialDto?> getAccountById(String userId) async {
    if (_cachedAccounts.isNotEmpty) return _cachedAccounts[userId];
    final allAccountsMap = await getAllAccounts();
    return allAccountsMap[userId];
  }

  Future<Map<String, UserCredentialDto>> getAllAccounts() async {
    if (_cachedAccounts.isNotEmpty) return _cachedAccounts;

    try {
      final encodedString = await _storage.read(AuthStorageKeys.allAccounts);
      if (encodedString?.isEmpty ?? true) return {};

      final decodedMap = jsonDecode(encodedString!) as Map<String, dynamic>;

      final map = decodedMap.map<String, UserCredentialDto>((key, value) {
        final userData = value as Map<String, dynamic>;
        return MapEntry(key, UserCredentialDto.fromJson(userData));
      });

      _cachedAccounts.addAll(map);
      return _cachedAccounts;
    } on Exception {
      rethrow;
    }
  }

  Future<String?> getAuthenticatedUserId() async {
    return _storage.read(AuthStorageKeys.currentUserId);
  }

  UserCredentialDto? get currentAccount => _currentAccSubject.value;

  Future<UserCredentialDto?> getCurrentAccount() async {
    final userId = await _storage.read(AuthStorageKeys.currentUserId);
    if (userId == null) return null;
    if (_cachedAccounts.isNotEmpty) return _cachedAccounts[userId];
    return getAccountById(userId);
  }

  Future<void> logout() async {
    _currentAccSubject.add(null);
    await _storage.delete(AuthStorageKeys.currentUserId);
    await _storage.delete(AuthStorageKeys.currentUserToken);
  }

  Future<void> removeAccount([String? userId]) async {
    _currentAccSubject.add(null);
    try {
      if (userId == null) {
        final currentUserId = await getAuthenticatedUserId();
        _cachedAccounts.remove(currentUserId);

        await _storage.delete(AuthStorageKeys.currentUserId);
        await _storage.delete(AuthStorageKeys.currentUserToken);
        await _saveAccountsMap(_cachedAccounts);
      } else {
        _cachedAccounts.remove(userId);
        await _saveAccountsMap(_cachedAccounts);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> _saveAccountsMap(Map<String, UserCredentialDto> map) async {
    try {
      final value = jsonEncode(map.map((key, v) => MapEntry(key, v.toJson())));
      return _storage.write(AuthStorageKeys.allAccounts, value: value);
    } on Exception {
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _currentAccSubject.close();
    await _allAccSub.close();
  }
}
