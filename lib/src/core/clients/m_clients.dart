import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:meno_fe_v1/src/features/auth/infrastructure/infrastructure.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';

/// A utility class for creating a Dio client with interceptors pre-configured.
///
/// This class provides a convenient way to create a Dio client with common
/// interceptors already set up. This can simplify your networking code and
/// ensure consistent behavior across your application.
class MClients {
  /// Creates a new Dio client with the specified base URL and pre-configured
  /// interceptors for authentication token handling and logging.
  ///
  /// [baseUrl] The base URL for the Dio client.
  ///
  /// Returns a newly created Dio client instance with the provided base URL
  /// and interceptors.
  static Dio dioClient(String baseUrl) {
    final dio = Dio()..options = BaseOptions(baseUrl: baseUrl);

    // Add interceptors to handle authentication token and logging
    dio.interceptors.addAll([
      AuthTokenInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false, // Prevent logging response headers
      ),
    ]);

    return dio;
  }
}

/// An interceptor for automatically adding an authorization token to requests
/// based on a stored user credential.
///
/// This interceptor retrieves the user credential from secure storage and, if
/// available, adds an "Authorization" header with a "Bearer" token to the
/// outgoing request. This helps to ensure requests are authenticated if a
/// valid token exists.
class AuthTokenInterceptor extends Interceptor {
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
    final storage = SecureStorageService(); // Assume this service exists
    final jsonString = await storage.read(MKeys.authUserCredentialKey);

    if (jsonString != null) {
      final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final credential = UserCredentialDto.fromJson(decodedJson);
      final token = credential.token;

      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }
}
