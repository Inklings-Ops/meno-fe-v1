import 'package:dio/dio.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno/core/core.dart';
import 'package:meno/core/di/scope_handler.dart';
import 'package:meno/features/auth/application/auth_manager.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';
import 'package:meno/shared/application/user_manager.dart';

void injectDependencies() {
  // ========================================================================
  // STORAGE LAYER
  // ========================================================================
  di.registerLazySingleton(FlutterSecureStorage.new);
  di.registerSingletonWithDependencies(
    () => SecureStorage(di<FlutterSecureStorage>()),
    dependsOn: [FlutterSecureStorage],
  );

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
  di.registerSingletonWithDependencies(
    () => SessionInterceptor(
      storage: di<SecureStorage>(),
      dio: di<Dio>(instanceName: 'refreshDio'),
      onSessionExpired: di<IAuthRepository>().logout,
      onTokenRefreshed: di<IAuthRepository>().initialize,
    ),
    dependsOn: [SecureStorage, Dio],
  );

  di.registerSingletonWithDependencies(
    () => ApiClient(
      baseUrl: Env.menoApiUrl,
      interceptors: [di<SessionInterceptor>(), di<LogInterceptor>()],
    ),
    dependsOn: [LogInterceptor, SessionInterceptor],
  );

  // ========================================================================
  // INFRASTRUCTURE LAYER
  // ========================================================================
  di.registerSingletonWithDependencies(
    () => AuthLocalDataSource(di<SecureStorage>()),
    dependsOn: [SecureStorage],
  );

  di.registerSingletonWithDependencies(
    () => AuthRemoteDataSource(di<ApiClient>()),
    dependsOn: [ApiClient],
  );

  di.registerSingletonAsync<IAuthRepository>(() async {
    final repository = AuthRepositoryImpl(
      local: di<AuthLocalDataSource>(),
      remote: di<AuthRemoteDataSource>(),
    );
    await repository.initialize();
    return repository;
  }, dependsOn: [AuthLocalDataSource, AuthRemoteDataSource]);

  // ========================================================================
  // APPLICATION LAYER
  // ========================================================================
  di.registerSingletonWithDependencies(
    () => AuthManager(di<IAuthRepository>()),
    dependsOn: [IAuthRepository],
  );

  di.registerSingletonWithDependencies(
    () => UserManager(di<IAuthRepository>()),
    dependsOn: [IAuthRepository],
  );

  // ========================================================================
  // OBSERVER
  // ========================================================================
  di.registerSingletonWithDependencies(
    () => ScopeHandler(di<IAuthRepository>()),
    dependsOn: [IAuthRepository],
  );

  // ========================================================================
  // PRESENTATION LAYER
  // ========================================================================
  di.registerSingletonWithDependencies(
    () => MenoRouter(di<IAuthRepository>()),
    dependsOn: [IAuthRepository],
  );
}
