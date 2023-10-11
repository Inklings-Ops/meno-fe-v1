import 'dart:io';

import 'package:dio/dio.dart' hide Headers;

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
    final token = await SecureStorageService().read(MKeys.currentUserTokenKey);

    if (token != null) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }
}
