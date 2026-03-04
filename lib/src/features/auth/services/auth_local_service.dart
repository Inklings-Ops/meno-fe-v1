import 'dart:convert';
import 'package:meno/src/_constants/constants.dart' show StorageKeys;
import 'package:meno/src/_shared/_shared.dart';
import 'package:meno/src/features/auth/dtos/dtos.dart';
import 'package:meno/src/features/auth/models/models.dart';

/// Infrastructure: Local persistence service for authentication.
final class AuthLocalService {
  const AuthLocalService(this._storage);

  final SecureStorage _storage;

  /// Emits the updated credential whenever the token changes on disk.
  Stream<UserCredentialDto?> get onCredentialChanged {
    return _storage.watchKey(StorageKeys.accessToken).asyncMap((token) async {
      if (token == null) return null;
      return getCredential();
    });
  }

  // ======================================================================
  // PRIMARY OPERATIONS (Complete Credential)
  // ======================================================================

  Future<void> saveCredential(UserCredentialDto dto) async {
    await Future.wait([
      _storage.write(StorageKeys.credential, value: jsonEncode(dto.toJson())),
      _storage.write(StorageKeys.userId, value: dto.user.id),
      _storage.write(StorageKeys.accessToken, value: dto.token),
      if (dto.refreshToken != null)
        _storage.write(StorageKeys.refreshToken, value: dto.refreshToken),
      if (dto.expiry != null)
        _storage.write(StorageKeys.sessionExpiry, value: dto.expiry),
    ]);
    await _updateStoredAccounts(dto);
  }

  Future<UserCredentialDto?> getCredential() async {
    final token = await _storage.read(StorageKeys.accessToken);
    if (token == null) return null;

    final jsonStr = await _storage.read(StorageKeys.credential);
    if (jsonStr != null) return UserCredentialDto.fromJson(jsonDecode(jsonStr));
    return null;
  }

  Future<void> clearCredential() async {
    await Future.wait([
      _storage.delete(StorageKeys.credential),
      _storage.delete(StorageKeys.userId),
      _storage.delete(StorageKeys.accessToken),
      _storage.delete(StorageKeys.refreshToken),
      _storage.delete(StorageKeys.sessionExpiry),
    ]);
  }

  // ======================================================================
  // FAST ACCESS METHODS (For Interceptor)
  // ======================================================================

  Future<Session?> getSession() async {
    try {
      final token = await _storage.read(StorageKeys.accessToken);
      if (token == null) return null;

      final refreshToken = await _storage.read(StorageKeys.refreshToken);
      final expiry = await _storage.read(StorageKeys.sessionExpiry);

      return Session.fromDto(
        token,
        refreshToken: refreshToken,
        explicitExpiry: expiry != null ? DateTime.tryParse(expiry) : null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> updateSession(Session session) async {
    final accessToken = session.accessToken.getOrCrash();
    final refreshToken = session.refreshToken.getOrNull();
    final expiry = session.expiry?.toIso8601String();

    await Future.wait([
      _storage.write(StorageKeys.accessToken, value: accessToken),
      _storage.write(StorageKeys.refreshToken, value: refreshToken),
      if (expiry != null)
        _storage.write(StorageKeys.sessionExpiry, value: expiry),
    ]);

    final currentCredential = await getCredential();
    if (currentCredential == null) return;

    final updatedCredential = UserCredentialDto(
      user: currentCredential.user,
      token: accessToken,
      refreshToken: refreshToken,
      expiry: expiry,
    );

    final value = jsonEncode(updatedCredential.toJson());
    await _storage.write(StorageKeys.credential, value: value);

    await _updateStoredAccounts(updatedCredential);
  }

  // ======================================================================
  // MULTI-ACCOUNT SUPPORT
  // ======================================================================

  Future<void> switchActiveUser(String targetUserId) async {
    final accounts = await getAllAccounts();
    final dto = accounts[targetUserId];
    if (dto == null) throw Exception('Target account not found');
    await saveCredential(dto);
  }

  Future<Map<String, UserCredentialDto>> getAllAccounts() async {
    final accountsJson = await _storage.read(StorageKeys.accounts);
    if (accountsJson == null) return {};

    try {
      final accountsMap = jsonDecode(accountsJson) as Map<String, dynamic>;
      final accounts = <String, UserCredentialDto>{};

      for (final entry in accountsMap.entries) {
        try {
          final dto = UserCredentialDto.fromJson(entry.value);
          accounts[entry.key] = dto;
        } catch (e) {
          continue;
        }
      }

      return accounts;
    } catch (e) {
      return {};
    }
  }

  /// Removes a specific account.
  Future<void> removeAccount(String userId) async {
    final accounts = await getAllAccounts();
    accounts.remove(userId);

    if (accounts.isEmpty) {
      await _storage.delete(StorageKeys.accounts);
    } else {
      final accountsMap = accounts.map((id, crd) => MapEntry(id, crd.toJson()));
      await _storage.write(
        StorageKeys.accounts,
        value: jsonEncode(accountsMap),
      );
    }

    // If removed account was current, clear current
    final currentUserId = await _storage.read(StorageKeys.userId);
    if (currentUserId == userId) await clearCredential();
  }

  Future<void> _updateStoredAccounts(UserCredentialDto dto) async {
    try {
      final accounts = await getAllAccounts();
      accounts[dto.user.id] = dto;
      final map = accounts.map((id, c) => MapEntry(id, c.toJson()));
      await _storage.write(StorageKeys.accounts, value: jsonEncode(map));
    } catch (e) {
      // Ignore
    }
  }
}
