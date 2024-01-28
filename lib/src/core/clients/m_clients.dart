import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;

import '../../features/auth/infrastructure/infrastructure.dart';
import '../../services/secure_storage_service.dart';
import '../../shared/m_keys.dart';

class MClients {
  static Dio dioClient(String baseUrl) {
    Dio dio = Dio()..options = BaseOptions();
    dio.interceptors.addAll([
      AuthTokenInterceptor(),
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    ]);
    return dio;
  }
}

class AuthTokenInterceptor extends Interceptor {
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = SecureStorageService();
    final jsonString = await storage.read(MKeys.authUserCredentialKey);

    if (jsonString != null) {
      final credential = UserCredentialDto.fromJson(jsonDecode(jsonString));
      final token = credential.token;

      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }
}
