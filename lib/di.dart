import 'package:dio/dio.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';

void injectDependencies() {
  // ========================================================================
  // STORAGE LAYER
  // ========================================================================
  di.registerLazySingleton(FlutterSecureStorage.new);
  di.registerLazySingleton(() => SecureStorage(di<FlutterSecureStorage>()));

  // ========================================================================
  // NETWORK LAYER
  // ========================================================================

  // Separate Dio instance for refresh requests (avoids interceptor loops)
  di.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: Env.menoApiUrl)),
    instanceName: 'refreshDio',
  );

  // Logging interceptor
  di.registerLazySingleton(LogInterceptor.new);

  // Session interceptor with session expiry callback
  di.registerLazySingleton(
    () => SessionInterceptor(
      storage: di<SecureStorage>(),
      dio: di<Dio>(instanceName: 'refreshDio'),
      onSessionExpired: di<IAuthRepository>().logout,
      onTokenRefreshed: di<IAuthRepository>().initialize,
    ),
  );

  di.registerLazySingleton(
    () => ApiClient(
      baseUrl: Env.menoApiUrl,
      interceptors: [di<SessionInterceptor>(), di<LogInterceptor>()],
    ),
  );

  // ========================================================================
  // INFRASTRUCTURE LAYER
  // ========================================================================
  di.registerLazySingleton(() => AuthLocalDataSource(di<SecureStorage>()));
  di.registerLazySingleton(() => AuthRemoteDataSource(di<ApiClient>()));
  di.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      local: di<AuthLocalDataSource>(),
      remote: di<AuthRemoteDataSource>(),
    )..initialize(),
    dispose: (param) => param.dispose(),
  );

  // ========================================================================
  // PRESENTATION LAYER
  // ========================================================================
  di.registerSingleton(MRouter.new);
}
