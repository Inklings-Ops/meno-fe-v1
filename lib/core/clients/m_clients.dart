import 'package:dio/dio.dart';

class MClients {
  static Dio dioClient(String baseUrl) {
    Dio dio = Dio()..options = BaseOptions();
    dio.interceptors.addAll([
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
