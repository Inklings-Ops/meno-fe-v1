// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i10;
import 'package:shared_preferences/shared_preferences.dart' as _i18;

import '../features/auth/application/auth/auth_notifier.dart' as _i26;
import '../features/auth/domain/domain.dart' as _i20;
import '../features/auth/infrastructure/auth_facade.dart' as _i21;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i19;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/broadcast/domain/domain.dart' as _i22;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i23;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i5;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i6;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i24;
import '../features/profile/domain/domain.dart' as _i27;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i25;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i16;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i15;
import '../features/profile/infrastructure/profile_facade.dart' as _i28;
import '../services/jwt_service.dart' as _i11;
import '../services/media_service.dart' as _i12;
import '../services/network_service.dart' as _i13;
import '../services/permissions_service.dart' as _i14;
import '../services/secure_storage_service.dart' as _i17;
import 'register_module.dart' as _i29;

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
    gh.lazySingleton<_i8.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i9.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i10.InternetConnectionChecker>(
        () => registerModule.connectionChecker);
    gh.lazySingleton<_i11.JWTService>(() => _i11.JWTService());
    gh.lazySingleton<_i12.MediaService>(
        () => _i12.MediaService(gh<_i9.ImagePicker>()));
    gh.factory<_i13.NetworkService>(
        () => _i13.NetworkService(gh<_i10.InternetConnectionChecker>()));
    await gh.factoryAsync<_i14.PermissionsService>(
      () {
        final i = _i14.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i15.ProfileMapper>(_i15.ProfileMapper());
    gh.lazySingleton<_i16.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i17.SecureStorageService>(
        () => _i17.SecureStorageService());
    await gh.factoryAsync<_i18.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i19.AuthLocalDatasource>(() =>
        _i19.AuthLocalDatasource(storage: gh<_i17.SecureStorageService>()));
    gh.lazySingleton<_i20.IAuthFacade>(() => _i21.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i19.AuthLocalDatasource>(),
          networkService: gh<_i13.NetworkService>(),
          jwtService: gh<_i11.JWTService>(),
        ));
    gh.lazySingleton<_i22.IBroadcastFacade>(() => _i23.BroadcastFacade(
          mapper: gh<_i6.BroadcastMapper>(),
          listMapper: gh<_i5.BroadcastListMapper>(),
          remote: gh<_i7.BroadcastRemoteDatasource>(),
          network: gh<_i13.NetworkService>(),
        ));
    gh.factory<_i24.OnboardingLocalDatasource>(() =>
        _i24.OnboardingLocalDatasource(storage: gh<_i18.SharedPreferences>()));
    gh.factory<_i25.ProfileLocalDatasource>(() =>
        _i25.ProfileLocalDatasource(storage: gh<_i17.SecureStorageService>()));
    await gh.factoryAsync<_i26.AuthNotifier>(
      () {
        final i = _i26.AuthNotifier(gh<_i20.IAuthFacade>());
        return i.checkAuthenticated().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i27.IProfileFacade>(() => _i28.ProfileFacade(
          authMapper: gh<_i15.ProfileMapper>(),
          remote: gh<_i16.ProfileRemoteDatasource>(),
          local: gh<_i25.ProfileLocalDatasource>(),
          network: gh<_i13.NetworkService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i29.RegisterModule {}
