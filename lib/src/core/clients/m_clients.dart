import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meno_fe_v1/src/config/config.dart' show AuthStorageKeys;
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:meno_fe_v1/src/services/services.dart';

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

  /// Removes only the expired user from storage without affecting others
  Future<void> _forceLogout() async {
    final currentUserId = await _storage.read(AuthStorageKeys.currentUserId);
    final accountsJson = await _storage.read(AuthStorageKeys.allAccounts);

    if (accountsJson != null && currentUserId != null) {
      final allAccounts = jsonDecode(accountsJson) as Map<String, dynamic>;
      allAccounts.remove(currentUserId);
      final updatedAccounts = jsonEncode(allAccounts);
      await _storage.write(AuthStorageKeys.allAccounts, value: updatedAccounts);
    }

    // Remove current user if it's the same as the expired one
    await _storage.delete(AuthStorageKeys.currentUserId);
    await _storage.delete(AuthStorageKeys.currentUserToken);
  }

  /// Retrieves the latest token from the [SecureStorageService]
  Future<String?> _getToken() async {
    final token = await _storage.read(AuthStorageKeys.currentUserToken);
    if (token != null && !JwtDecoder.isExpired(token)) {
      return token;
    } else {
      await _forceLogout();
      return null;
    }
  }

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
    final token = await _getToken();
    if (token != null) options.headers['authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }
}
