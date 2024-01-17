import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/services/jwt_service.dart';

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

  Future<bool> get hasAllUserCredentials {
    return _storage.hasKey(MKeys.allUserCredentialsKey);
  }

  Future<bool> get hasToken async =>
      await getCurrentUserToken == null ? false : true;

  Future<bool> get hasUser => _storage.hasKey(MKeys.currentUserKey);

  /// Deletes all auth data from the local storage.
  Future<void> deleteAll() => _storage.deleteAll();

  Future<void> deleteCurrentUserCredentials() => Future.wait([
        _storage.delete(MKeys.currentUserKey),
        _storage.delete(MKeys.currentUserTokenKey),
      ]);

  Future<void> deleteCurrentUserToken() =>
      _storage.delete(MKeys.currentUserTokenKey);

  Future<Map<String, UserCredentialsDto>?> get getAllUserCredentials async {
    final encodedString = await _storage.read(MKeys.allUserCredentialsKey);

    if (encodedString != null) {
      final decodedMap = jsonDecode(encodedString) as Map<String, dynamic>;
      final userCredentialsMap = decodedMap.map(
        (key, value) => MapEntry(
          key,
          UserCredentialsDto.fromJson(value as Map<String, dynamic>),
        ),
      );
      return userCredentialsMap;
    }
    return null;
  }

  Future<UserDto?> get getCurrentUser async {
    final jsonString = await _storage.read(MKeys.currentUserKey);
    if (jsonString == null) {
      return null;
    }
    return UserDto.fromJson(jsonDecode(jsonString));
  }

  Future<UserToken?> get getCurrentUserToken async {
    final token = await _storage.read(MKeys.currentUserTokenKey);

    if (token == null) {
      return null;
    }

    final jwt = JWTService();
    if (jwt.isExpired(token)) {
      return null;
    }

    return token;
  }

  Future<UserCredentialsDto?> getUserCredentialById(String id) async {
    final credentialMap = await getAllUserCredentials;
    return credentialMap?[id];
  }

  Future<void> storeAllUserCredentials(UserCredentialsDto dto) async {
    final credentialsMap = await getAllUserCredentials ?? {};
    credentialsMap[dto.user.id] = dto;

    final encodedString = jsonEncode(credentialsMap);
    await _storage.write(MKeys.allUserCredentialsKey, value: encodedString);
  }

  Future<void> storeCurrentToken(UserToken token) async {
    await _storage.write(MKeys.currentUserTokenKey, value: token);
  }

  Future<void> storeCurrentUser(UserDto dto) async {
    final encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.currentUserKey, value: encodedString);
  }
}
