import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/model/model.dart';

/// Production-grade auth interceptor with zero external dependencies.
///
/// Features:
/// - Automatic token injection
/// - Proactive token refresh
/// - Request queuing during refresh
/// - Multi-account session management
/// - Zero coupling to domain layer
///
/// Architecture:
/// - Only interacts with SecureStorage
/// - No callbacks or dependencies on repositories
/// - Domain layer observes storage changes reactively
class SessionInterceptor extends QueuedInterceptor {
  SessionInterceptor({
    required SecureStorage storage,
    required Dio dio,
    String refreshEndpoint = '/users/refresh',
  }) : _storage = storage,
       _dio = dio,
       _refreshEndpoint = refreshEndpoint;

  final SecureStorage _storage;
  final Dio _dio;
  final String _refreshEndpoint;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  // ======================================================================
  // REQUEST INTERCEPTION
  // ======================================================================

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    try {
      final sessionOption = await _getCurrentSession();

      await sessionOption.match(() async => handler.next(options), (
        session,
      ) async {
        if (session.shouldRefresh()) {
          if (_isRefreshing) {
            // Wait for ongoing refresh
            await _refreshCompleter?.future;
            final newSession = await _getCurrentSession();
            newSession.match(() => handler.next(options), (s) {
              _injectToken(options, s);
              handler.next(options);
            });
          } else {
            // Initiate refresh
            final refreshResult = await _refreshToken(session);

            await refreshResult.match(
              (error) async {
                await _handleSessionExpired();
                handler.reject(
                  DioException(
                    requestOptions: options,
                    error: 'Session expired',
                    type: DioExceptionType.badResponse,
                  ),
                );
              },
              (newSession) async {
                _injectToken(options, newSession);
                handler.next(options);
              },
            );
          }
        } else {
          _injectToken(options, session);
          handler.next(options);
        }
      });
    } catch (e) {
      debugPrint('SessionInterceptor.onRequest error: $e');
      handler.next(options);
    }
  }

  // ======================================================================
  // ERROR INTERCEPTION
  // ======================================================================

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      if (_isAuthEndpoint(requestOptions.path)) {
        return handler.next(err);
      }

      try {
        final sessionOption = await _getCurrentSession();

        await sessionOption.match(
          () async {
            await _handleSessionExpired();
            handler.next(err);
          },
          (session) async {
            final refreshResult = await _refreshToken(session);

            await refreshResult.match(
              (error) async {
                await _handleSessionExpired();
                handler.next(err);
              },
              (newSession) async {
                // Retry original request
                final retryOptions = requestOptions.copyWith();
                _injectToken(retryOptions, newSession);

                try {
                  final response = await _dio.fetch<dynamic>(retryOptions);
                  handler.resolve(response);
                } catch (e) {
                  handler.next(err);
                }
              },
            );
          },
        );
      } catch (e) {
        debugPrint('SessionInterceptor.onError error: $e');
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  // ======================================================================
  // TOKEN REFRESH LOGIC
  // ======================================================================

  Future<Either<MenoException, Session>> _refreshToken(Session session) async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return _getCurrentSession().then(
        (option) => option.match(
          () => left(const ServerException('Session expired')),
          right,
        ),
      );
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final response = await _dio.post<dynamic>(
        _refreshEndpoint,
        data: {'refreshToken': session.refreshToken.getOrNull()},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${session.accessToken.getOrNull()}',
          },
        ),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException('Invalid refresh response');
      }

      final responseDto = ResponseDto.fromJson(data, (json) => json);

      if (responseDto.hasError || !responseDto.status) {
        throw ServerException(responseDto.error ?? 'Token refresh failed');
      }

      final credentialDto = UserCredentialDto.fromJson(responseDto.data);
      final newCredential = credentialDto.toDomain;

      // ✅ CRITICAL: Just save to storage, repository will observe
      await _saveSession(newCredential);

      _refreshCompleter?.complete();
      return right(newCredential.session);
    } on DioException catch (e) {
      _refreshCompleter?.completeError(e);
      if (e.response?.statusCode == 401) {
        return left(const ServerException('Refresh token expired'));
      }
      return left(const ServerException('Token refresh failed'));
    } catch (e) {
      _refreshCompleter?.completeError(e);
      return left(UnknownException(e.toString()));
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  // ======================================================================
  // SESSION MANAGEMENT (Storage Only)
  // ======================================================================

  Future<Option<Session>> _getCurrentSession() async {
    try {
      final token = await _storage.read(StorageKeys.accessToken);
      if (token == null) return none();

      final refreshToken = await _storage.read(StorageKeys.refreshToken);
      final expiryStr = await _storage.read(StorageKeys.sessionExpiry);

      final expiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;

      return some(
        Session.fromDto(
          token,
          refreshToken: refreshToken,
          explicitExpiry: expiry,
        ),
      );
    } catch (e) {
      debugPrint('Error getting session: $e');
      return none();
    }
  }

  /// Saves session to storage using batch operations for performance
  Future<void> _saveSession(UserCredential credential) async {
    try {
      final session = credential.session;
      final userId = credential.user.id.getOrCrash();

      // ✅ Use batch write for better performance
      await _storage.writeBatch({
        StorageKeys.accessToken: session.accessToken.getOrElse((_) => ''),
        StorageKeys.refreshToken: session.refreshToken.getOrNull(),
        StorageKeys.userId: userId,
        StorageKeys.sessionExpiry: session.expiry?.toIso8601String(),
        StorageKeys.credential: jsonEncode(credential.toDto.toJson()),
      });

      // Update accounts vault
      await _updateStoredAccounts(credential);
    } catch (e) {
      debugPrint('Error saving session: $e');
      rethrow;
    }
  }

  Future<void> _updateStoredAccounts(UserCredential credential) async {
    try {
      final accountsJson = await _storage.read(StorageKeys.accounts);
      final accounts = accountsJson != null
          ? jsonDecode(accountsJson) as Map<String, dynamic>
          : <String, dynamic>{};

      final userId = credential.user.id.getOrCrash();
      accounts[userId] = credential.toDto.toJson();

      await _storage.write(StorageKeys.accounts, value: jsonEncode(accounts));
    } catch (e) {
      debugPrint('Error updating accounts: $e');
      // Non-critical, don't rethrow
    }
  }

  /// Handles session expiration by clearing storage
  ///
  /// ✅ NO CALLBACKS: Repository observes storage changes automatically
  Future<void> _handleSessionExpired() async {
    try {
      // ✅ Use batch delete for performance
      await _storage.deleteBatch([
        StorageKeys.userId,
        StorageKeys.accessToken,
        StorageKeys.refreshToken,
        StorageKeys.sessionExpiry,
        StorageKeys.credential,
      ]);

      // Repository will detect these changes via storage.onChange stream
      // and update its state accordingly
    } catch (e) {
      debugPrint('Error handling session expiry: $e');
    }
  }

  // ======================================================================
  // HELPERS
  // ======================================================================

  void _injectToken(RequestOptions options, Session session) {
    final token = session.accessToken.getOrElse((_) => '');
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  bool _isAuthEndpoint(String path) {
    const authPaths = [
      '/users/signin/google',
      '/users/signup/google',
      '/users/signin',
      '/users/signup',
      '/users/email/verify',
      '/users/password/forgot',
      '/users/password/reset',
      '/users/password/otp',
    ];

    return authPaths.any((authPath) => path.contains(authPath));
  }
}
