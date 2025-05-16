import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';

/// An interceptor for automatically adding an authorization token to requests
/// based on a stored user credential.
///
/// This interceptor retrieves the user credential from secure storage and, if
/// available, adds an "Authorization" header with a "Bearer" token to the
/// outgoing request. This helps to ensure requests are authenticated if a
/// valid token exists.
@lazySingleton
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({required SecureStorageService storage})
      : _storage = storage;
  final SecureStorageService _storage;

  /// Handles errors that occur during the HTTP request/response lifecycle.
  ///
  /// This method is typically overridden to implement custom error handling
  /// logic. In this case, we simply delegate to the superclass implementation.
  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    return super.onError(err, handler);
  }

  /// Modifies the request options before sending a request.
  ///
  /// This method allows you to intercept the request and potentially modify
  /// the options before it is sent. Here, we retrieve the stored user
  /// credential, if present, and add an "Authorization" header with a "Bearer"
  /// token to the request options.
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final credentials = await _storage.read(MKeys.allCredentials);
    final authUserId = await _storage.read(MKeys.authUserId);
    if (credentials != null && authUserId != null) {
      final decodedMap = jsonDecode(credentials) as Map<String, dynamic>;
      final authCredential = decodedMap[authUserId] as Map<String, dynamic>?;

      if (authCredential != null) {
        final userCredential = UserCredentialDto.fromJson(authCredential);
        final token = userCredential.token;
        if (token != null && !JwtDecoder.isExpired(token)) {
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        }
      }
    }
    return super.onRequest(options, handler);
  }
}
