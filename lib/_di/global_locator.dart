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
import 'package:meno/features/broadcast/services/broadcast_local_service.dart';
import 'package:meno/features/onboarding/onboarding.dart';
import 'package:meno/features/settings/services/settings_local_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kRootScope = 'root-session';

void configureGlobalDependencies() {
  // Push te root-session scope
  di.pushNewScope(scopeName: kRootScope);

  // Local Storage
  di.registerSingletonAsync(SharedPreferences.getInstance);
  di.registerSingletonWithDependencies(() {
    return LocalStorage(di<SharedPreferences>());
  }, dependsOn: [SharedPreferences]);

  // Secure Storage
  di.registerSingletonAsync(() async => const FlutterSecureStorage());
  di.registerSingletonWithDependencies(() {
    return SecureStorage(di<FlutterSecureStorage>());
  }, dependsOn: [FlutterSecureStorage]);

  // ObjectBox Database
  di.registerSingletonAsync<Database>(Database.create);

  // Media
  di.registerSingletonAsync(() async => ImagePicker());
  di.registerSingletonWithDependencies(() {
    return MediaService(di<ImagePicker>());
  }, dependsOn: [ImagePicker]);

  // Permissions
  di.registerSingletonAsync(() async {
    return PermissionsService();
  }, onCreated: (manager) => manager.checkPermissions.run());

  // Rest API Client Resources
  di.registerSingleton(Logger.new);
  di.registerSingletonAsync(() async => LogInterceptor());
  di.registerFactory<Dio>(() {
    return Dio(BaseOptions(baseUrl: Env.menoApiUrl));
  }, instanceName: 'refreshDio');
  di.registerSingletonAsync(() async {
    return SessionInterceptor(
      storage: di<SecureStorage>(),
      dio: di<Dio>(instanceName: 'refreshDio'),
    );
  }, dependsOn: [SecureStorage]);
  di.registerSingletonWithDependencies(() {
    return HttpClient(
      baseUrl: Env.menoApiUrl,
      interceptors: [di<SessionInterceptor>(), di<LogInterceptor>()],
    );
  }, dependsOn: [SessionInterceptor, LogInterceptor]);

  // Onboarding
  di.registerSingletonWithDependencies(() {
    return OnboardingService(di<LocalStorage>());
  }, dependsOn: [LocalStorage]);
  di.registerSingletonWithDependencies(() {
    final manager = OnboardingManager(di<OnboardingService>());
    manager.initialize.run();
    return manager;
  }, dependsOn: [OnboardingService]);

  // Auth
  di.registerSingletonWithDependencies(() {
    return AuthLocalService(di<SecureStorage>());
  }, dependsOn: [SecureStorage]);
  di.registerSingletonWithDependencies(() {
    return AuthHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    return AuthManager(
      http: di<AuthHttpService>(),
      local: di<AuthLocalService>(),
      onboarding: di<OnboardingService>(),
    );
  }, dependsOn: [AuthHttpService, AuthLocalService, OnboardingService]);

  // Bible
  di.registerSingletonWithDependencies(() {
    return BibleLocalService(di<Database>());
  }, dependsOn: [Database]);
  di.registerSingletonWithDependencies(() {
    return BibleHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    return BibleManager(di<BibleLocalService>());
  }, dependsOn: [BibleLocalService, TranslationsManager]);
  di.registerSingletonWithDependencies(() {
    final manager = TranslationsManager(
      di<BibleHttpService>(),
      di<BibleLocalService>(),
    );
    manager.initialize.run();
    return manager;
  }, dependsOn: [BibleHttpService, BibleLocalService]);

  /**
   * Broadcast Local Service
   *
   * So, this is bumped up to the global locator so it can be registered
   * before above the user scope to enable easy retrieval and reconnection for
   * "zombie" broadcasts
   */
  di.registerSingletonWithDependencies(() {
    return BroadcastLocalService(
      storage: di<LocalStorage>(),
      database: di<Database>(),
    );
  }, dependsOn: [LocalStorage, Database]);

  /**
   * Settings Local Service
   *
   * This is also bumped up to the global locator so we can easily access the
   * user's local settings (if any) on initial load before syncing with the
   * remote source.
   */
  di.registerSingletonWithDependencies(() {
    return SettingsLocalService(di<LocalStorage>());
  }, dependsOn: [LocalStorage]);

  // Router
  di.registerSingletonWithDependencies(() {
    return MenoRouter(
      auth: di<AuthManager>(),
      onboarding: di<OnboardingManager>(),
    );
  }, dependsOn: [AuthManager]);
}
