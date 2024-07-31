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

  /// Deletes all auth data from the local storage.
  Future<void> deleteAll() => _storage.deleteAll();

  Future<void> deleteCurrentUserCredential() =>
      _storage.delete(MKeys.authUserCredentialKey);

  Future<Map<String, UserCredentialDto>?> get getAllUserCredentials async {
    final encodedString = await _storage.read(MKeys.allUserCredentialsKey);

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

  Future<UserDto?> get getCurrentUser async {
    final credential = await getUserCredential();
    return credential?.user;
  }

  Future<String?> get getCurrentUserToken async {
    final credential = await getUserCredential();
    return credential?.token;
  }

  Future<UserCredentialDto?> getUserCredential() async {
    final jsonString = await _storage.read(MKeys.authUserCredentialKey);
    if (jsonString == null) return null;
    final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserCredentialDto.fromJson(decodedJson);
  }

  Future<UserCredentialDto?> getUserCredentialById(String id) async {
    final credentialMap = await getAllUserCredentials;
    return credentialMap?[id];
  }

  Future<void> storeAuthUserCredentials(UserCredentialDto dto) async {
    final encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.authUserCredentialKey, value: encodedString);
  }

  Future<void> storeAllUserCredentials(UserCredentialDto dto) async {
    final credentialsMap = await getAllUserCredentials ?? {};
    credentialsMap[dto.user.id] = dto;

    final encodedString = jsonEncode(credentialsMap);
    await _storage.write(MKeys.allUserCredentialsKey, value: encodedString);
  }

  Future<void> storeAuthCombined(UserCredentialDto dto) async {
    await Future.wait([
      storeAuthUserCredentials(dto),
      storeAllUserCredentials(dto),
    ]);
  }
}
