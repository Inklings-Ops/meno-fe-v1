import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/infrastructure/dtos/user_credential_dto.dart';

/// High-performance auth interceptor with token refresh and request queuing.
///
/// Features:
/// - Automatic token injection into requests
/// - Token expiry detection and refresh
/// - Request queuing during token refresh (prevents race conditions)
/// - Multi-account session management
/// - Automatic logout on refresh failure
///
/// Architecture:
/// - Uses QueuedInterceptor to prevent concurrent refresh attempts
/// - Manages token lifecycle independently of UI layer
/// - Maintains session state in secure storage
class SessionInterceptor extends QueuedInterceptor {
  SessionInterceptor({
    required SecureStorage storage,
    required Dio dio,
    String refreshEndpoint = '/users/refresh',
    Future<void> Function()? onSessionExpired,
    void Function(UserCredential credential)? onTokenRefreshed,
  }) : _storage = storage,
       _dio = dio,
       _refreshEndpoint = refreshEndpoint,
       _onSessionExpired = onSessionExpired,
       _onTokenRefreshed = onTokenRefreshed;

  /// Secure storage for session data
  final SecureStorage _storage;

  /// Separate Dio instance for refresh requests
  final Dio _dio;

  /// Endpoint for refreshing tokens
  final String _refreshEndpoint;

  /// Callback for session expiration
  final Future<void> Function()? _onSessionExpired;

  /// Callback for refreshing the token
  final void Function(UserCredential credential)? _onTokenRefreshed;

  /// Track if we're currently refreshing to prevent duplicate refresh calls
  bool _isRefreshing = false;

  /// Completer for pending requests waiting for token refresh
  Completer<void>? _refreshCompleter;

  // ======================================================================
  // REQUEST INTERCEPTION
  // ======================================================================

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token injection for auth endpoints
    if (_isAuthEndpoint(options.path)) return handler.next(options);

    try {
      final sessionOption = await _getCurrentSession();

      await sessionOption.match(
        // No session found - proceed without token
        () async => handler.next(options),
        (session) async {
          // Use the extension method
          if (session.shouldRefresh()) {
            // Wait for refresh if already in progress
            if (_isRefreshing) {
              await _refreshCompleter?.future;
              final newSession = await _getCurrentSession();
              newSession.match(() => handler.next(options), (s) {
                _injectToken(options, s);
                handler.next(options);
              });
            } else {
              // Initiate token refresh
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
            // Token is still fresh - inject it
            _injectToken(options, session);
            handler.next(options);
          }
        },
      );
    } on Exception catch (e) {
      debugPrint('SessionInterceptor error: $e');
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
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // Don't retry auth endpoints
      if (_isAuthEndpoint(requestOptions.path)) return handler.next(err);

      try {
        final sessionOption = await _getCurrentSession();

        await sessionOption.match(
          () async {
            // No session - can't retry
            await _handleSessionExpired();
            handler.next(err);
          },
          (session) async {
            // Attempt to refresh token
            final refreshResult = await _refreshToken(session);

            await refreshResult.match(
              (error) async {
                // Refresh failed - logout and propagate error
                await _handleSessionExpired();
                handler.next(err);
              },
              (newSession) async {
                // Refresh succeeded - retry original request
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
      } on Exception catch (e) {
        debugPrint('SessionInterceptor error: $e');
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  // ======================================================================
  // TOKEN REFRESH LOGIC
  // ======================================================================

  /// Refreshes the access token using the refresh token
  Future<Either<MenoException, Session>> _refreshToken(Session session) async {
    // If already refreshing, wait for completion
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
      // Call refresh endpoint
      final response = await _dio.post<dynamic>(
        _refreshEndpoint,
        data: {'refreshToken': session.refreshToken.getOrNull()},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${session.accessToken.getOrNull()}',
          },
        ),
      );

      // Parse response
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException('Invalid refresh response');
      }

      final mResponse = MenoResponse.fromJson(data, (json) => json);

      if (mResponse.hasError || !mResponse.status) {
        throw ServerException(mResponse.globalError ?? 'Token refresh failed');
      }

      // Parse new credentials
      final credentialDto = UserCredentialDto.fromJson(mResponse.data);
      final newCredential = credentialDto.toDomain;

      // Save new session
      await _saveSession(newCredential);
      _onTokenRefreshed?.call(newCredential);
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
  // SESSION MANAGEMENT
  // ======================================================================

  /// Retrieves the current session from storage
  Future<Option<Session>> _getCurrentSession() async {
    try {
      final tokenJson = await _storage.read(StorageKeys.accessToken);
      final refreshTokenJson = await _storage.read(StorageKeys.refreshToken);

      if (tokenJson == null) return none();

      final session = Session.fromDto(
        tokenJson,
        refreshToken: refreshTokenJson,
      );

      return some(session);
    } on Exception catch (e) {
      debugPrint('Error retrieving current session: $e');
      return none();
    }
  }

  /// Saves session to secure storage
  Future<void> _saveSession(UserCredential credential) async {
    final session = credential.session;
    final userId = credential.user.id;

    await Future.wait([
      _storage.write(
        StorageKeys.accessToken,
        value: session.accessToken.getOrElse((_) => ''),
      ),

      _storage.write(
        StorageKeys.refreshToken,
        value: session.refreshToken.getOrNull() ?? '',
      ),

      _storage.write(StorageKeys.userId, value: userId.getOrCrash()),

      if (session.expiry != null)
        _storage.write(
          StorageKeys.sessionExpiry,
          value: session.expiry!.toIso8601String(),
        ),
    ]);

    // Update stored accounts
    await _updateStoredAccounts(credential);
  }

  /// Updates the stored accounts map with new credential
  Future<void> _updateStoredAccounts(UserCredential credential) async {
    try {
      final accountsJson = await _storage.read(StorageKeys.accounts);
      final accounts = accountsJson != null
          ? jsonDecode(accountsJson) as Map<String, dynamic>
          : <String, dynamic>{};

      final userId = credential.user.id.getOrCrash();
      accounts[userId] = credential.toDto.toJson();

      await _storage.write(StorageKeys.accounts, value: jsonEncode(accounts));
    } on Exception catch (e) {
      // Log error but don't block the flow
      debugPrint('Error updating stored accounts: $e');
    }
  }

  /// Handles session expiration - clears storage and triggers callback
  Future<void> _handleSessionExpired() async {
    final currentUserId = await _storage.read(StorageKeys.userId);

    if (currentUserId != null) {
      // Remove expired account from stored accounts
      final accountsJson = await _storage.read(StorageKeys.accounts);
      if (accountsJson != null) {
        final accounts = jsonDecode(accountsJson) as Map<String, dynamic>;
        accounts.remove(currentUserId);
        await _storage.write(StorageKeys.accounts, value: jsonEncode(accounts));
      }
    }

    // Clear current session
    await Future.wait([
      _storage.delete(StorageKeys.userId),
      _storage.delete(StorageKeys.accessToken),
      _storage.delete(StorageKeys.refreshToken),
      _storage.delete(StorageKeys.sessionExpiry),
    ]);

    // Notify listeners (e.g., navigate to login)
    await _onSessionExpired?.call();
  }

  // ======================================================================
  // HELPER METHODS
  // ======================================================================

  /// Injects Bearer token into request headers
  void _injectToken(RequestOptions options, Session session) {
    final token = session.accessToken.getOrElse((_) => '');
    if (token.isNotEmpty) options.headers['Authorization'] = 'Bearer $token';
  }

  /// Determines if token should be refreshed
  /// Returns true if:
  /// - Token is already expired
  /// - Token expires within the refresh threshold (5 minutes)
  ///
  /// Returns false if:
  /// - No refresh token available (can't refresh)
  /// - No expiry info (opaque tokens)
  /// - Token is still fresh
  bool _shouldRefreshToken(Session session) {
    // No refresh token available - can't refresh
    if (session.refreshToken.getOrNull() == null) return false;

    // No expiry info - assume token is valid (opaque token scenario)
    if (session.expiry == null) return false;

    // Check if already expired
    if (session.isExpired) return true;

    // Check if expiring soon (within 5 minutes)
    final now = DateTime.now();
    final threshold = session.expiry!.subtract(const Duration(minutes: 5));

    return now.isAfter(threshold);
  }

  /// Checks if endpoint is an auth endpoint (skip token injection)
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
