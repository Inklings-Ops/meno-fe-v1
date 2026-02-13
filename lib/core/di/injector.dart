import 'package:dio/dio.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/application/auth_manager.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';
import 'package:meno/shared/application/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupDependencies() {
  // Push the base scope
  di.pushNewScope(scopeName: 'root');

  di.registerSingleton(Logger.new);

  di.registerSingletonAsync(() async => ImagePicker());

  di.registerSingletonWithDependencies(
    () => MediaService(di<ImagePicker>()),
    dependsOn: [ImagePicker],
  );

  di.registerSingletonAsync(() async {
    final service = PermissionsService();
    service.checkPermissions.run();
    return service;
  });

  // ========================================================================
  // STORAGE LAYER
  // ========================================================================
  di.registerSingletonAsync(SharedPreferences.getInstance);

  di.registerSingletonWithDependencies(
    () => LocalStorage(di<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  di.registerSingletonAsync(() async => const FlutterSecureStorage());

  di.registerSingletonWithDependencies(
    () => SecureStorage(di<FlutterSecureStorage>()),
    dependsOn: [FlutterSecureStorage],
  );

  // ========================================================================
  // NETWORK LAYER
  // ========================================================================

  // Separate Dio instance for refresh requests (avoids interceptor loops)
  di.registerFactory<Dio>(
    () => Dio(BaseOptions(baseUrl: Env.menoApiUrl)),
    instanceName: 'refreshDio',
  );

  // Logging interceptor
  di.registerSingletonAsync(() async => LogInterceptor());

  // Session interceptor with session expiry callback
  di.registerSingletonAsync(
    () async => SessionInterceptor(
      storage: di<SecureStorage>(),
      dio: di<Dio>(instanceName: 'refreshDio'),
    ),
    dependsOn: [SecureStorage],
  );

  di.registerSingletonWithDependencies(
    () => ApiClient(
      baseUrl: Env.menoApiUrl,
      interceptors: [di<SessionInterceptor>(), di<LogInterceptor>()],
    ),
    dependsOn: [SessionInterceptor, LogInterceptor],
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
    () => UserScopeHandler(di<IAuthRepository>()),
    dependsOn: [IAuthRepository],
  );

  // ========================================================================
  // PRESENTATION LAYER
  // ========================================================================
  di.registerLazySingleton(() => MenoRouter(di<IAuthRepository>()));
}
