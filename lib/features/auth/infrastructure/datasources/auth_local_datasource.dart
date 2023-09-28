import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user_credentials.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/dtos/user_credentials_dto.dart';
import 'package:meno_fe_v1/services/secure_storage_service.dart';
import 'package:meno_fe_v1/shared/m_keys.dart';

/// A local data source for authentication.
@injectable
class AuthLocalDatasource {
  /// The secure storage service.
  final SecureStorageService _storage;

  /// Creates a new `AuthLocalDatasource` object.
  AuthLocalDatasource({required SecureStorageService storage})
      : _storage = storage;

  /// Deletes all auth data from the local storage.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Deletes the user's credentials from the local storage.
  Future<void> deleteUserCredentials() async {
    await _storage.delete(MKeys.userCredentialsKey);
  }

  /// Deletes the user's token from the local storage.
  Future<void> deleteUserToken() async {
    await _storage.delete(MKeys.userTokenKey);
  }

  /// Gets the user's credentials from the local storage.
  ///
  /// Returns a `Future` that completes to the user's credentials, or `null` if the user's credentials are not stored in the local storage.
  Future<UserCredentialsDto?> getUserCredentials() async {
    final String? jsonString = await _storage.read(MKeys.userCredentialsKey);
    if (jsonString == null) {
      return null;
    }
    return UserCredentialsDto.fromJson(jsonDecode(jsonString));
  }

  /// Gets the user's token from the local storage.
  ///
  /// Returns a `Future` that completes to the user's token, or `null` if the user's token is not stored in the local storage.
  Future<UserToken?> getUserToken() async {
    final String? token = await _storage.read(MKeys.userTokenKey);
    if (token == null) {
      return null;
    }
    return token;
  }

  /// Stores the user's token in the local storage.
  Future<void> storeToken(UserToken token) async {
    await _storage.write(MKeys.userTokenKey, value: token);
  }

  /// Stores the user's credentials in the local storage.
  Future<void> storeUserCredentials(UserCredentialsDto dto) async {
    final String encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.userCredentialsKey, value: encodedString);
  }
}
