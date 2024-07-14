import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/services/jwt_service.dart';

import '../../services/secure_storage_service.dart';

class MIsolates {
  static final _storage = SecureStorageService();
  static final _auth = AuthLocalDatasource(storage: _storage);

  MIsolates._();

  static Future<List<dynamic>> authResult(RootIsolateToken rootIsolateToken) {
    return Isolate.run(() => _authIsolate(rootIsolateToken));
  }

  static Future<Map<String, UserCredential>?> _getAllUserCredentials() async {
    final map = await _auth.getAllUserCredentials;
    if (map != null) {
      final userCredentialsMap = map.map((key, value) {
        final userCredentials = value.toDomain;
        return MapEntry(key, userCredentials);
      });

      return userCredentialsMap;
    }
    return null;
  }

  static Future<User?> _getCurrentUser() async {
    final userDto = await _auth.getCurrentUser;
    final userDomain = userDto?.toDomain;
    return userDomain;
  }

  static Future<String?> _getCurrentUserToken() async {
    final userToken = await _auth.getCurrentUserToken;
    final jwt = JWTService();

    if (userToken == null) {
      return null;
    }

    if (jwt.isExpired(userToken)) {
      return null;
    } else {
      return userToken;
    }
  }

  static Future<List<dynamic>> _authIsolate(RootIsolateToken token) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    final result = await Future.wait([
      _getCurrentUser(),
      _getCurrentUserToken(),
      _getAllUserCredentials(),
    ]);

    return result;
  }
}
