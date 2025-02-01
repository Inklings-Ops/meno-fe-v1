import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';

/// A local data source for authentication.
@injectable
class AuthLocalDatasource {
  /// Creates a new `AuthLocalDatasource` object.
  AuthLocalDatasource({required SecureStorageService storage})
      : _storage = storage;

  /// The secure storage service.
  final SecureStorageService _storage;

  // Future<UserCredentialDto?> getUserCredentialById(String id) async {
  //   final credentialMap = await getAllUserCredentials();
  //   return credentialMap?[id];
  // }

  /// Deletes all auth data from the local storage.
  Future<void> deleteAll() => _storage.deleteAll();

  Future<void> deleteAuthCredential() async {
    try {
      final authUserId = await getAuthUserId();
      final allCredentials = await getAllUserCredentials();
      if (allCredentials != null && authUserId != null) {
        allCredentials.remove(authUserId);
        await _saveCredentialsMap(allCredentials);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteAuthToken() async {
    try {
      return _storage.delete(MKeys.authToken);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, UserCredentialDto>?> getAllUserCredentials() async {
    final encodedString = await _storage.read(MKeys.allCredentials);
    if (encodedString != null) {
      final decodedMap = jsonDecode(encodedString) as Map<String, dynamic>;
      final userCredentialsMap = decodedMap.map(
        (key, value) => MapEntry(
          key,
          UserCredentialDto.fromJson(value as Map<String, dynamic>),
        ),
      );
      return userCredentialsMap;
    }
    return null;
  }

  Future<UserCredentialDto?> getAuthCredential() async {
    final allCredentials = await getAllUserCredentials();
    if (allCredentials == null) return null;
    final authUserId = await getAuthUserId();
    return allCredentials[authUserId];
  }

  Future<String?> getAuthToken() async {
    final credential = await getAuthCredential();
    return credential?.token;
  }

  Future<String?> getAuthUserId() async {
    final authUserId = await _storage.read(MKeys.authUserId);
    return authUserId;
  }

  Future<void> storeCredentials(
    UserCredentialDto credential, {
    bool isCurrent = true,
  }) async {
    final userId = credential.user.id;
    final credentialsMap = await getAllUserCredentials() ?? {};
    credentialsMap[userId] = credential;
    try {
      if (isCurrent) {
        await _storage.write(MKeys.authUserId, value: userId);
        await _storage.write(MKeys.authToken, value: credential.token);
      }
      await _saveCredentialsMap(credentialsMap);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _saveCredentialsMap(Map<String, UserCredentialDto>? map) async {
    final encodedString = jsonEncode(map);
    return _storage.write(MKeys.allCredentials, value: encodedString);
  }
}
