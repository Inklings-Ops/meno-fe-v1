import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';

// ========================================================================
// TYPE DEFINITIONS
// ========================================================================

/// Parser for domain models from response data
typedef FromJson<T> = T Function(dynamic json);

/// Success callback for monitoring
typedef OnSuccess = void Function(RequestOptions request, Response response);

/// Error callback for monitoring
typedef OnError = void Function(DioException error, StackTrace stackTrace);

// ========================================================================
// API CLIENT
// ========================================================================

class ApiClient {
  ApiClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    List<Interceptor>? interceptors,
    OnSuccess? onSuccess,
    OnError? onError,
  }) : _onSuccess = onSuccess,
       _onError = onError,
       _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           sendTimeout: sendTimeout,
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
             ...?headers,
           },
           validateStatus: (status) {
             // Accept all status codes, handle them in our error logic
             return status != null;
           },
         ),
       ) {
    if (interceptors != null) _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;
  final OnSuccess? _onSuccess;
  final OnError? _onError;

  // ======================================================================
  // HTTP METHODS
  // ======================================================================

  Future<Either<MenoException, T>> get<T>(
    String path, {
    required FromJson<T> fromJson,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = true,
  }) async {
    return _executeRequest(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      retry: retry,
    );
  }

  Future<Either<MenoException, List<T>>> getList<T>(
    String path, {
    required FromJson<T> fromJson,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = true,
  }) async {
    return _executeRequest(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: (json) {
        if (json is! List) throw const UnknownException('Expected List');
        return json.map((item) => fromJson(item)).toList();
      },
      isList: true,
      retry: retry,
    );
  }

  Future<Either<MenoException, T>> post<T>(
    String path, {
    required FromJson<T> fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      retry: retry,
    );
  }

  Future<Either<MenoException, T>> put<T>(
    String path, {
    required FromJson<T> fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      retry: retry,
    );
  }

  Future<Either<MenoException, T>> patch<T>(
    String path, {
    required FromJson<T> fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      retry: retry,
    );
  }

  Future<Either<MenoException, T>> delete<T>(
    String path, {
    required FromJson<T> fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      retry: retry,
    );
  }

  // ======================================================================
  // UNIT RETURNS (No response body expected)
  // ======================================================================

  Future<Either<MenoException, Unit>> postUnit(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: (_) => unit,
      retry: retry,
    );
  }

  Future<Either<MenoException, Unit>> deleteUnit(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: (_) => unit,
      retry: retry,
    );
  }

  Future<Either<MenoException, Unit>> putUnit(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool retry = false,
  }) async {
    return _executeRequest(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      fromJson: (_) => unit,
      retry: retry,
    );
  }

  // ======================================================================
  // FILE UPLOAD & DOWNLOAD
  // ======================================================================

  Future<Either<MenoException, T>> upload<T>(
    String path, {
    required FromJson<T> fromJson,
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest(
      () => _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      retry: false,
    );
  }

  Future<Either<MenoException, Unit>> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
      );
      return right(unit);
    } on DioException catch (e, st) {
      _onError?.call(e, st);
      return left(_handleDioError(e));
    } catch (e, st) {
      _onError?.call(
        DioException(requestOptions: RequestOptions(), error: e),
        st,
      );
      return left(UnknownException(e.toString()));
    }
  }

  // ======================================================================
  // CORE EXECUTION LOGIC
  // ======================================================================

  Future<Either<MenoException, T>> _executeRequest<T>(
    Future<Response> Function() request, {
    required FromJson<T> fromJson,
    bool isList = false,
    bool retry = true,
    int maxRetries = 3,
  }) async {
    var attempts = 0;

    while (true) {
      try {
        final response = await request();

        // Invoke success callback
        _onSuccess?.call(response.requestOptions, response);

        // Parse MenoResponse wrapper
        final mResponse = _parseMenoResponse(response);

        // Check for errors in MenoResponse
        if (mResponse.hasError) return left(_handleMenoError(mResponse));

        // Check status field
        if (!mResponse.status) {
          return left(ServerException(mResponse.message ?? 'Request failed'));
        }

        // Extract and parse the actual data
        final result = _parseData(mResponse.data, fromJson, isList);

        return right(result);
      } on DioException catch (e, st) {
        _onError?.call(e, st);

        // Check if should retry
        if (retry && attempts < maxRetries && _shouldRetry(e)) {
          attempts++;
          await Future.delayed(Duration(seconds: 1 << (attempts - 1)));
          continue;
        }

        return left(_handleDioError(e));
      } catch (e, st) {
        _onError?.call(
          DioException(requestOptions: RequestOptions(), error: e),
          st,
        );
        return left(UnknownException(e.toString()));
      }
    }
  }

  // ======================================================================
  // PARSING LOGIC
  // ======================================================================

  /// Parse the outer MenoResponse wrapper
  MenoResponse<dynamic> _parseMenoResponse(Response response) {
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw UnknownException(
        'Expected Map<String, dynamic> but got ${data.runtimeType}',
      );
    }

    return MenoResponse.fromJson(data, (json) => json);
  }

  /// Parse the inner data field
  T _parseData<T>(dynamic data, FromJson<T> fromJson, bool isList) {
    if (data == null) {
      // For Unit returns or empty responses
      if (T == Unit) return unit as T;
      throw const UnknownException('Response data is null');
    }

    if (isList) {
      if (data is! List) {
        throw UnknownException('Expected List but got ${data.runtimeType}');
      }
      return data.map((item) => fromJson(item)).toList() as T;
    }

    return fromJson(data);
  }

  // ======================================================================
  // ERROR HANDLING
  // ======================================================================

  /// Handle errors from MenoResponse (backend validation errors)
  MenoException _handleMenoError(MenoResponse response) {
    // Field validation errors (e.g., {"email": "invalid", "name": "required"})
    if (response.fieldErrors != null && response.fieldErrors!.isNotEmpty) {
      return ValidationException(response.fieldErrors!);
    }

    // Global error string
    if (response.globalError != null) {
      // Check for common error types
      final error = response.globalError!.toLowerCase();
      if (error.contains('unauthorized') || error.contains('unauthenticated')) {
        return ServerException(response.globalError!);
      }
      if (error.contains('forbidden')) {
        return ServerException(response.globalError!);
      }
      if (error.contains('not found')) {
        return ServerException(response.globalError!);
      }
      return ServerException(response.globalError!);
    }

    // Fallback to message
    return ServerException(response.message ?? 'Request failed');
  }

  /// Handle Dio network/connection errors
  MenoException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.badResponse:
        // Try to parse MenoResponse from error response
        if (e.response?.data is Map<String, dynamic>) {
          try {
            final menoResponse = MenoResponse.fromJson(
              e.response!.data as Map<String, dynamic>,
              (json) => json,
            );
            return _handleMenoError(menoResponse);
          } catch (_) {
            // If parsing fails, fall through to default handling
          }
        }
        return ServerException(
          e.response?.statusMessage ?? 'Server error occurred',
        );

      case DioExceptionType.cancel:
        return const UnknownException('Request was cancelled');

      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return const NetworkException();
        }
        return const NetworkException();

      case DioExceptionType.badCertificate:
        return const ServerException('SSL certificate error');

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NetworkException();
        }
        return UnknownException(
          e.error?.toString() ?? e.message ?? 'Unknown error occurred',
        );
    }
  }

  /// Determines if a request should be retried
  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        (e.type == DioExceptionType.connectionError &&
            e.error is SocketException);
  }

  // ======================================================================
  // UTILITIES
  // ======================================================================

  Dio get raw => _dio;

  CancelToken createCancelToken() => CancelToken();

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}
