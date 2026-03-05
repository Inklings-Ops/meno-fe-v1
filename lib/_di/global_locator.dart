import 'package:dio/dio.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:meno/_core/env/env.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/bible/bible.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kRootScopeName = 'root-session';

void configureGlobalDependencies() {
  di.pushNewScope(scopeName: kRootScopeName);
  di.registerSingleton(Logger.new);
  di.registerSingletonAsync(SharedPreferences.getInstance);
  di.registerSingletonAsync(() async => ImagePicker());
  di.registerSingletonAsync(() async => const FlutterSecureStorage());
  di.registerSingletonWithDependencies(
    () => MediaService(di<ImagePicker>()),
    dependsOn: [ImagePicker],
  );
  di.registerSingletonAsync(() async {
    return PermissionsService();
  }, onCreated: (manager) => manager.checkPermissions.run());
  di.registerSingletonAsync<Database>(Database.create);
  di.registerSingletonWithDependencies(
    () => LocalStorage(di<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );
  di.registerSingletonWithDependencies(
    () => SecureStorage(di<FlutterSecureStorage>()),
    dependsOn: [FlutterSecureStorage],
  );
  di.registerSingletonAsync(() async => LogInterceptor());
  di.registerFactory<Dio>(
    () => Dio(BaseOptions(baseUrl: Env.menoApiUrl)),
    instanceName: 'refreshDio',
  );
  di.registerSingletonAsync(
    () async => SessionInterceptor(
      storage: di<SecureStorage>(),
      dio: di<Dio>(instanceName: 'refreshDio'),
    ),
    dependsOn: [SecureStorage],
  );
  di.registerSingletonWithDependencies(
    () => HttpClient(
      baseUrl: Env.menoApiUrl,
      interceptors: [di<SessionInterceptor>(), di<LogInterceptor>()],
    ),
    dependsOn: [SessionInterceptor, LogInterceptor],
  );

  // Auth
  di.registerSingletonWithDependencies(
    () => AuthLocalService(di<SecureStorage>()),
    dependsOn: [SecureStorage],
  );
  di.registerSingletonWithDependencies(
    () => AuthHttpService(di<HttpClient>()),
    dependsOn: [HttpClient],
  );
  di.registerSingletonWithDependencies(
    () => AuthManager(di<AuthHttpService>(), di<AuthLocalService>()),
    dependsOn: [AuthHttpService, AuthLocalService],
  );

  // Bible
  di.registerSingletonWithDependencies(
    () => BibleLocalService(di<Database>()),
    dependsOn: [Database],
  );

  di.registerSingletonWithDependencies(
    () => BibleHttpService(di<HttpClient>()),
    dependsOn: [HttpClient],
  );

  di.registerSingletonAsync(() async {
    final manager = TranslationsManager(
      di<BibleHttpService>(),
      di<BibleLocalService>(),
    );
    manager.initialize.run();
    return manager;
  }, dependsOn: [BibleHttpService, BibleLocalService]);

  di.registerSingletonWithDependencies(() {
    return BibleManager(di<BibleLocalService>());
  }, dependsOn: [BibleLocalService, TranslationsManager]);

  // Router
  di.registerSingletonWithDependencies(
    () => MenoRouter(di<AuthManager>()),
    dependsOn: [AuthManager],
  );
}
