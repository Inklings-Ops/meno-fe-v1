// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../meno.dart' as _i1014;
import '../core/network/domain/i_network_facade.dart' as _i305;
import '../core/network/infrastructure/network_facade.dart' as _i479;
import '../features/auth/auth.dart' as _i236;
import '../features/auth/infrastructure/auth_facade.dart' as _i790;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i882;
import '../features/bible/bible.dart' as _i652;
import '../features/bible/infrastructure/bible_facade.dart' as _i442;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i664;
import '../features/broadcast/broadcast.dart' as _i625;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i1031;
import '../features/broadcast/infrastructure/datasources/broadcast_local_datasource.dart'
    as _i396;
import '../features/chat/chat.dart' as _i506;
import '../features/chat/infrastructure/chat_facade.dart' as _i536;
import '../features/features.dart' as _i1009;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i933;
import '../features/notes/infrastructure/note_facade.dart' as _i176;
import '../features/notes/notes.dart' as _i1042;
import '../features/notifications/domain/i_notification_facade.dart' as _i168;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i589;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i236;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i734;
import '../features/profile/domain/domain.dart' as _i74;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i517;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i212;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i865;
import '../features/profile/infrastructure/profile_facade.dart' as _i920;
import '../features/settings/infrastructure/datasources/settings_local_datasource.dart'
    as _i385;
import '../features/settings/infrastructure/settings_facade.dart' as _i838;
import '../features/settings/settings.dart' as _i709;
import '../services/background_service.dart' as _i879;
import '../services/jwt_service.dart' as _i431;
import '../services/live_kit/live_kit_service.dart' as _i691;
import '../services/media_service.dart' as _i586;
import '../services/network_service.dart' as _i463;
import '../services/notification_service.dart' as _i941;
import '../services/objectbox_service.dart' as _i116;
import '../services/permissions_service.dart' as _i179;
import '../services/secure_storage_service.dart' as _i535;
import '../services/services.dart' as _i264;
import '../shared/session/cubit/session_cubit.dart' as _i607;
import '../shared/session/session_context.dart' as _i320;
import '../shared/shared.dart' as _i44;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i116.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    gh.singleton<_i865.ProfileMapper>(() => _i865.ProfileMapper());
    gh.singleton<_i236.NotificationsMapper>(() => _i236.NotificationsMapper());
    gh.singleton<_i179.PermissionsService>(() => _i179.PermissionsService());
    gh.lazySingleton<_i1009.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.lazySingleton<_i1009.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i1009.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.lazySingleton<_i1009.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i1009.BibleRemoteDatasource>(
        () => registerModule.bibleRemoteDatasource);
    gh.lazySingleton<_i1009.ChatRemoteDatasource>(
        () => registerModule.chatRemoteDatasource);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i1009.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i892.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i691.LiveKitService>(() => _i691.LiveKitService());
    gh.lazySingleton<_i431.JWTService>(() => _i431.JWTService());
    gh.lazySingleton<_i879.BackgroundService>(() => _i879.BackgroundService());
    gh.lazySingleton<_i535.SecureStorageService>(
        () => _i535.SecureStorageService());
    gh.factory<_i664.BibleLocalDatasource>(() =>
        _i664.BibleLocalDatasource(objectBox: gh<_i116.ObjectBoxService>()));
    gh.factory<_i933.NoteLocalDatasource>(() =>
        _i933.NoteLocalDatasource(objectBox: gh<_i264.ObjectBoxService>()));
    await gh.factoryAsync<_i941.NotificationService>(
      () {
        final i = _i941.NotificationService(
          firebaseMessaging: gh<_i1014.FirebaseMessaging>(),
          storageService: gh<_i535.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i463.NetworkService>(
        () => _i463.NetworkService(gh<_i973.InternetConnectionChecker>()));
    gh.factory<_i882.AuthLocalDatasource>(() =>
        _i882.AuthLocalDatasource(storage: gh<_i535.SecureStorageService>()));
    gh.factory<_i517.ProfileLocalDatasource>(() => _i517.ProfileLocalDatasource(
        storage: gh<_i535.SecureStorageService>()));
    gh.factory<_i396.BroadcastLocalDatasource>(() =>
        _i396.BroadcastLocalDatasource(
            storage: gh<_i264.SecureStorageService>()));
    gh.lazySingleton<_i305.INetworkFacade>(() => _i479.NetworkFacade(
        connectivity: gh<_i973.InternetConnectionChecker>()));
    gh.lazySingleton<_i586.MediaService>(
        () => _i586.MediaService(gh<_i183.ImagePicker>()));
    gh.factory<_i385.SettingsLocalDatasource>(() =>
        _i385.SettingsLocalDatasource(
            preferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i168.INotificationFacade>(() => _i734.NotificationFacade(
          remoteDatasource: gh<_i589.NotificationRemoteDatasource>(),
          networkService: gh<_i463.NetworkService>(),
        ));
    gh.factory<_i709.ISettingsFacade>(
        () => _i838.SettingsFacade(local: gh<_i709.SettingsLocalDatasource>()));
    gh.factory<_i1042.INoteFacade>(() => _i176.NoteFacade(
          network: gh<_i264.NetworkService>(),
          local: gh<_i1042.NoteLocalDatasource>(),
          remote: gh<_i1042.NoteRemoteDatasource>(),
        ));
    gh.factory<_i652.IBibleFacade>(() => _i442.BibleFacade(
          local: gh<_i652.BibleLocalDatasource>(),
          remote: gh<_i652.BibleRemoteDatasource>(),
          network: gh<_i463.NetworkService>(),
        ));
    gh.factory<_i506.IChatFacade>(() => _i536.ChatFacade(
          remote: gh<_i506.ChatRemoteDatasource>(),
          network: gh<_i264.NetworkService>(),
        ));
    gh.factory<_i625.IBroadcastFacade>(() => _i1031.BroadcastFacade(
          remote: gh<_i625.BroadcastRemoteDatasource>(),
          local: gh<_i625.BroadcastLocalDatasource>(),
          network: gh<_i264.NetworkService>(),
        ));
    await gh.factoryAsync<_i236.IAuthFacade>(
      () {
        final i = _i790.AuthFacade(
          remoteDatasource: gh<_i236.AuthRemoteDatasource>(),
          localDatasource: gh<_i236.AuthLocalDatasource>(),
          networkService: gh<_i264.NetworkService>(),
          jwtService: gh<_i264.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i74.IProfileFacade>(() => _i920.ProfileFacade(
          remote: gh<_i212.ProfileRemoteDatasource>(),
          local: gh<_i517.ProfileLocalDatasource>(),
          network: gh<_i463.NetworkService>(),
        ));
    gh.factory<_i44.ISessionContext>(() => _i320.SessionContext(
          authFacade: gh<_i236.IAuthFacade>(),
          settingsFacade: gh<_i709.ISettingsFacade>(),
        ));
    await gh.factoryAsync<_i607.SessionCubit>(
      () {
        final i = _i607.SessionCubit(session: gh<_i44.ISessionContext>());
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
