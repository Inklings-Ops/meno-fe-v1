import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/features/auth/domain/entities/user_credentials.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/dtos/user_dto.dart';
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

  /// Deletes the user's token from the local storage.
  Future<void> deleteUserToken() async {
    await _storage.delete(MKeys.userTokenKey);
  }

  /// Gets the user's credentials from the local storage.
  ///
  /// Returns a `Future` that completes to the user's credentials, or `null` if the user's credentials are not stored in the local storage.
  Future<UserDto?> getUser() async {
    final String? jsonString = await _storage.read(MKeys.userKey);
    if (jsonString == null) {
      return null;
    }
    return UserDto.fromJson(jsonDecode(jsonString));
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

  /// Returns `true` if the user has a user object stored but no token, `false` otherwise.
  Future<bool> hasUserButNoToken() async {
    final bool hasUser = await _storage.hasKey(MKeys.userKey);
    return hasUser;
  }

  /// Returns `true` if the user is logged in, `false` otherwise.
  Future<bool> isLoggedIn() async {
    final bool hasUserToken = await _storage.hasKey(MKeys.userTokenKey);
    final bool hasUser = await _storage.hasKey(MKeys.userKey);
    return (hasUser && hasUserToken);
  }

  /// Stores the user's token in the local storage.
  Future<void> storeToken(UserToken token) async {
    await _storage.write(MKeys.userTokenKey, value: token);
  }

  /// Stores the user's credentials in the local storage.
  Future<void> storeUser(UserDto dto) async {
    final String encodedString = jsonEncode(dto.toJson());
    await _storage.write(MKeys.userKey, value: encodedString);
  }
}
