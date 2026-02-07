import 'dart:convert';

import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';

final class AuthLocalDataSource {
  const AuthLocalDataSource(this._storage);

  final SecureStorage _storage;

  // ======================================================================
  // PRIMARY OPERATIONS (Complete Credential)
  // ======================================================================

  /// Saves the complete credential with individual field caching.
  ///
  /// Strategy:
  /// 1. Store complete credential as JSON (source of truth)
  /// 2. Cache individual fields for fast interceptor access
  Future<void> saveCredential(UserCredentialDto dto) async {
    // Batch write for atomicity
    await Future.wait([
      // Complete credential (source of truth)
      _storage.write(StorageKeys.credential, value: jsonEncode(dto.toJson())),

      // Cached fields for fast access
      _storage.write(StorageKeys.userId, value: dto.user.id),
      _storage.write(StorageKeys.accessToken, value: dto.token),

      if (dto.refreshToken != null)
        _storage.write(StorageKeys.refreshToken, value: dto.refreshToken),

      if (dto.expiry != null)
        _storage.write(StorageKeys.sessionExpiry, value: dto.expiry),
    ]);

    // Update multi-account storage
    await _updateStoredAccounts(dto);
  }

  /// Retrieves the complete credential.
  Future<UserCredentialDto?> getCredential() async {
    // We read the 'Hot Keys' directly. Fast.
    final token = await _storage.read(StorageKeys.accessToken);
    if (token == null) return null;

    // If we have a token but no full user data, we might need to fetch from
    // the Vault. But for the simple check, we construct what we have.
    // Ideally, you read the full JSON blob for the 'credential' key you
    // already save.
    final jsonStr = await _storage.read(StorageKeys.credential);
    if (jsonStr != null) return UserCredentialDto.fromJson(jsonDecode(jsonStr));
    return null;
  }

  /// Clears all credential data (logout).
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

  /// Gets just the session (no JSON parsing of user data).
  ///
  /// Used by: SessionInterceptor (called on every request)
  /// Priority: Speed over completeness
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

  /// Updates just the session tokens (after refresh).
  ///
  /// Strategy:
  /// 1. Update cached fields immediately (for interceptor)
  /// 2. Then update complete credential (for consistency)
  Future<void> updateSession(Session session) async {
    final accessToken = session.accessToken.getOrElse((_) => '');
    final refreshToken = session.accessToken.getOrNull();
    final expiry = session.expiry?.toIso8601String();

    // First, update cached fields
    await Future.wait([
      _storage.write(StorageKeys.accessToken, value: accessToken),
      _storage.write(StorageKeys.refreshToken, value: refreshToken),
      if (expiry != null)
        _storage.write(StorageKeys.sessionExpiry, value: expiry),
    ]);

    // Then, update complete credential for consistency
    final currentCredential = await getCredential();

    if (currentCredential == null) return;

    // Create updated credential with new session
    final updatedCredential = UserCredentialDto(
      user: currentCredential.user,
      token: accessToken,
      refreshToken: refreshToken,
      expiry: expiry,
    );

    // Update complete credential
    final value = jsonEncode(updatedCredential.toJson());
    await _storage.write(StorageKeys.credential, value: value);

    // Update accounts
    await _updateStoredAccounts(updatedCredential);
  }

  // ======================================================================
  // MULTI-ACCOUNT SUPPORT
  // ======================================================================

  /// Switches the active user by copying from Vault -> Hot Cache
  Future<void> switchActiveUser(String targetUserId) async {
    final accounts = await getAllAccounts();
    final dto = accounts[targetUserId];

    if (dto == null) throw const StorageException('Target account not found');

    // OVERWRITE the Hot Keys with the target user's data.
    // The Interceptor will immediately start using this new token.
    await saveCredential(dto);
  }

  /// Gets all stored accounts.
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
          // Skip corrupted accounts
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
      final accountsMap = accounts.map(
        (id, credential) => MapEntry(id, credential.toJson()),
      );
      await _storage.write(
        StorageKeys.accounts,
        value: jsonEncode(accountsMap),
      );
    }

    // If removed account was current, clear current
    final currentUserId = await _storage.read(StorageKeys.userId);
    if (currentUserId == userId) {
      await clearCredential();
    }
  }

  /// Updates the stored accounts map with current credential.
  Future<void> _updateStoredAccounts(UserCredentialDto dto) async {
    try {
      final accounts = await getAllAccounts();
      final userId = dto.user.id;

      accounts[userId] = dto;

      final map = accounts.map((id, c) => MapEntry(id, c.toJson()));
      await _storage.write(StorageKeys.accounts, value: jsonEncode(map));
    } catch (e) {
      // Don't block the flow if multi-account storage fails
    }
  }

  // ======================================================================
  // VALIDATION & MIGRATION
  // ======================================================================

  /// Validates stored data integrity.
  ///
  /// Checks if cached fields match the complete credential.
  /// Useful for debugging or migration scenarios.
  Future<bool> validateIntegrity() async {
    final credential = await getCredential();
    if (credential == null) return false;

    final cachedToken = await _storage.read(StorageKeys.accessToken);
    return cachedToken == credential.token;
  }

  /// Repairs storage if cached fields don't match credential.
  Future<void> repairStorage() async {
    final credential = await getCredential();
    if (credential == null) return clearCredential();
    return saveCredential(credential);
  }
}
