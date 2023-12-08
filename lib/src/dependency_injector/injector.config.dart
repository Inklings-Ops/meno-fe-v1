// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i8;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i9;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i11;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i12;
import 'package:shared_preferences/shared_preferences.dart' as _i22;

import '../features/auth/application/auth/auth_notifier.dart' as _i33;
import '../features/auth/domain/domain.dart' as _i24;
import '../features/auth/infrastructure/auth_facade.dart' as _i25;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i23;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/broadcast/domain/domain.dart' as _i26;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i27;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i5;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i6;
import '../features/notifications/domain/i_notification_facade.dart' as _i28;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i16;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i17;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i29;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i31;
import '../features/profile/domain/domain.dart' as _i34;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i32;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i20;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i19;
import '../features/profile/infrastructure/profile_facade.dart' as _i35;
import '../services/jwt_service.dart' as _i13;
import '../services/media_service.dart' as _i14;
import '../services/network_service.dart' as _i15;
import '../services/notification_service.dart' as _i30;
import '../services/permissions_service.dart' as _i18;
import '../services/secure_storage_service.dart' as _i21;
import 'register_module.dart' as _i36;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.AuthMapper>(_i3.AuthMapper());
    gh.lazySingleton<_i4.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.singleton<_i5.BroadcastListMapper>(_i5.BroadcastListMapper());
    gh.singleton<_i6.BroadcastMapper>(_i6.BroadcastMapper());
    gh.lazySingleton<_i7.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i8.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i9.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i10.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i11.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i12.InternetConnectionChecker>(
        () => registerModule.connectionChecker);
    gh.lazySingleton<_i13.JWTService>(() => _i13.JWTService());
    gh.lazySingleton<_i14.MediaService>(
        () => _i14.MediaService(gh<_i11.ImagePicker>()));
    gh.factory<_i15.NetworkService>(
        () => _i15.NetworkService(gh<_i12.InternetConnectionChecker>()));
    gh.lazySingleton<_i16.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.singleton<_i17.NotificationsMapper>(_i17.NotificationsMapper());
    await gh.factoryAsync<_i18.PermissionsService>(
      () {
        final i = _i18.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i19.ProfileMapper>(_i19.ProfileMapper());
    gh.lazySingleton<_i20.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i21.SecureStorageService>(
        () => _i21.SecureStorageService());
    await gh.factoryAsync<_i22.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i23.AuthLocalDatasource>(() =>
        _i23.AuthLocalDatasource(storage: gh<_i21.SecureStorageService>()));
    gh.lazySingleton<_i24.IAuthFacade>(() => _i25.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i23.AuthLocalDatasource>(),
          networkService: gh<_i15.NetworkService>(),
          jwtService: gh<_i13.JWTService>(),
        ));
    gh.lazySingleton<_i26.IBroadcastFacade>(() => _i27.BroadcastFacade(
          mapper: gh<_i6.BroadcastMapper>(),
          listMapper: gh<_i5.BroadcastListMapper>(),
          remote: gh<_i7.BroadcastRemoteDatasource>(),
          network: gh<_i15.NetworkService>(),
        ));
    gh.lazySingleton<_i28.INotificationFacade>(() => _i29.NotificationFacade(
          remoteDatasource: gh<_i16.NotificationRemoteDatasource>(),
          networkService: gh<_i15.NetworkService>(),
        ));
    await gh.factoryAsync<_i30.NotificationService>(
      () {
        final i = _i30.NotificationService(
          firebaseMessaging: gh<_i8.FirebaseMessaging>(),
          storageService: gh<_i21.SecureStorageService>(),
          localNotifications: gh<_i9.FlutterLocalNotificationsPlugin>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i31.OnboardingLocalDatasource>(() =>
        _i31.OnboardingLocalDatasource(storage: gh<_i22.SharedPreferences>()));
    gh.factory<_i32.ProfileLocalDatasource>(() =>
        _i32.ProfileLocalDatasource(storage: gh<_i21.SecureStorageService>()));
    await gh.factoryAsync<_i33.AuthNotifier>(
      () {
        final i = _i33.AuthNotifier(gh<_i24.IAuthFacade>());
        return i.checkAuthenticated().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i34.IProfileFacade>(() => _i35.ProfileFacade(
          authMapper: gh<_i19.ProfileMapper>(),
          remote: gh<_i20.ProfileRemoteDatasource>(),
          local: gh<_i32.ProfileLocalDatasource>(),
          network: gh<_i15.NetworkService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i36.RegisterModule {}
