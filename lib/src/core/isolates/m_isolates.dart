import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/services/jwt_service.dart';

import '../../features/auth/domain/domain.dart';
import '../../features/auth/infrastructure/datasources/auth_local_datasource.dart';
import '../../features/auth/infrastructure/mapper/auth_mapper.dart';
import '../../services/secure_storage_service.dart';

class MIsolates {
  static final AuthMapper _authMapper = AuthMapper();

  static final _storage = SecureStorageService();
  static final _auth = AuthLocalDatasource(storage: _storage);

  MIsolates._();

  static Future<List<dynamic>> authResult(RootIsolateToken rootIsolateToken) {
    return Isolate.run(() => _authIsolate(rootIsolateToken));
  }

  static Future<Map<String, UserCredentials>?> _getAllUserCredentials() async {
    final map = await _auth.getAllUserCredentials;
    if (map != null) {
      final userCredentialsMap = map.map((key, value) {
        final userCredentials = _authMapper.userCredentialsToDomain(value)!;
        return MapEntry(key, userCredentials);
      });

      return userCredentialsMap;
    }
    return null;
  }

  static Future<User?> _getCurrentUser() async {
    final userDto = await _auth.getCurrentUser;
    final User? userDomain = _authMapper.userToDomain(userDto);
    return userDomain;
  }

  static Future<String?> _getCurrentUserToken() async {
    final userToken = await _auth.getCurrentUserToken;
    final jwt = JWTService();

    if (userToken == null) {
      Logger().w('FROM AUTH ISOLATE => TOKEN IS NULL');
      return null;
    }

    if (jwt.isExpired(userToken)) {
      Logger().w('FROM AUTH ISOLATE => TOKEN IS EXPIRED');
      return null;
    } else {
      Logger().w('FROM AUTH ISOLATE => TOKEN IS AVAILABLE');
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
