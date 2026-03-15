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

  // Core Resources
  di.registerSingleton<Logger>(Logger());
  di.registerSingleton<InteractionManager>(InteractionManager());

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
  di.registerSingletonAsync(
    () async {
      // Construct the manager (wires all commands), then:
      // 1. startListening() — subscribes to onCredentialChanged AFTER all
      //    commands are ready, so _onAuthChanged never fires against a
      //    partially-constructed manager.
      // 2. initialize.run() — kicks off session restoration asynchronously.
      //    get_it's allReady() does NOT need to wait for this; the router's
      //    refreshListenable (activeUserId) will drive navigation once
      //    _restoreSession completes and updates state.
      final manager = AuthManager(
        http: di<AuthHttpService>(),
        local: di<AuthLocalService>(),
      );
      manager.startListening();
      manager.initialize.run();
      return manager;
    },
    dependsOn: [AuthHttpService, AuthLocalService, OnboardingService],
    signalsReady: true,
  );
  di.registerSingletonWithDependencies(
    () => UserManager(di<AuthManager>()),
    dependsOn: [AuthManager],
  );
  // Bible
  di.registerSingletonWithDependencies(() {
    return BibleLocalService(di<Database>());
  }, dependsOn: [Database]);
  di.registerSingletonWithDependencies(() {
    return BibleHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    return BibleManager(di<BibleLocalService>());
  }, dependsOn: [BibleLocalService]);
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

  // User Scope Manager
  di.registerSingletonAsync(() async {
    final scope = UserScopeManager(di<AuthManager>());
    await scope.initialize();
    return scope;
  }, dependsOn: [AuthManager, OnboardingService]);

  // Router
  di.registerLazySingleton(() {
    return MenoRouter.create();
  });
}
