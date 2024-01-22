import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../services/secure_storage_service.dart';
import '../../../../shared/m_keys.dart';
import '../../domain/domain.dart';
import '../dtos/dtos.dart';

/// A local data source for authentication.
@injectable
class AuthLocalDatasource {
  /// The secure storage service.
  final SecureStorageService _storage;

  /// Creates a new `AuthLocalDatasource` object.
  AuthLocalDatasource({required SecureStorageService storage})
      : _storage = storage;

  /// Deletes all auth data from the local storage.
  Future<void> deleteAll() => _storage.deleteAll();

  Future<void> deleteCurrentUserCredential() =>
      _storage.delete(MKeys.authUserCredentialKey);

  Future<void> deleteCurrentUserToken() =>
      _storage.delete(MKeys.authUserTokenKey);

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

  Future<UserToken?> get getCurrentUserToken async {
    final credential = await getUserCredential();
    return credential?.token;
  }

  Future<UserCredentialDto?> getUserCredential() async {
    final jsonString = await _storage.read(MKeys.authUserCredentialKey);

    if (jsonString == null) return null;

    return UserCredentialDto.fromJson(jsonDecode(jsonString));
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

  Future<void> storeCurrentToken(UserToken token) async {
    await _storage.write(MKeys.authUserTokenKey, value: token);
  }

  Future<void> storeCurrentUser(UserDto dto) async {
    final encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.authUserKey, value: encodedString);
  }
}
