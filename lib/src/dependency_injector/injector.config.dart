// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i7;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i8;
import 'package:shared_preferences/shared_preferences.dart' as _i14;

import '../features/auth/application/auth/auth_notifier.dart' as _i21;
import '../features/auth/domain/domain.dart' as _i16;
import '../features/auth/infrastructure/auth_facade.dart' as _i17;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i15;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/broadcast/domain/domain.dart' as _i18;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i19;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i6;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i5;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i20;
import '../services/jwt_service.dart' as _i9;
import '../services/media_service.dart' as _i10;
import '../services/network_service.dart' as _i11;
import '../services/permissions_service.dart' as _i12;
import '../services/secure_storage_service.dart' as _i13;
import 'register_module.dart' as _i22;

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
    gh.singleton<_i5.BroadcastMapper>(_i5.BroadcastMapper());
    gh.lazySingleton<_i6.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i7.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i8.InternetConnectionChecker>(
        () => registerModule.connectionChecker);
    gh.lazySingleton<_i9.JWTService>(() => _i9.JWTService());
    gh.lazySingleton<_i10.MediaService>(
        () => _i10.MediaService(gh<_i7.ImagePicker>()));
    gh.factory<_i11.NetworkService>(
        () => _i11.NetworkService(gh<_i8.InternetConnectionChecker>()));
    await gh.factoryAsync<_i12.PermissionsService>(
      () {
        final i = _i12.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i13.SecureStorageService>(
        () => _i13.SecureStorageService());
    await gh.factoryAsync<_i14.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i15.AuthLocalDatasource>(() =>
        _i15.AuthLocalDatasource(storage: gh<_i13.SecureStorageService>()));
    gh.lazySingleton<_i16.IAuthFacade>(() => _i17.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i15.AuthLocalDatasource>(),
          networkService: gh<_i11.NetworkService>(),
          jwtService: gh<_i9.JWTService>(),
        ));
    gh.lazySingleton<_i18.IBroadcastFacade>(() => _i19.BroadcastFacade(
          mapper: gh<_i5.BroadcastMapper>(),
          remote: gh<_i6.BroadcastRemoteDatasource>(),
          network: gh<_i11.NetworkService>(),
        ));
    gh.factory<_i20.OnboardingLocalDatasource>(() =>
        _i20.OnboardingLocalDatasource(storage: gh<_i14.SharedPreferences>()));
    await gh.factoryAsync<_i21.AuthNotifier>(
      () {
        final i = _i21.AuthNotifier(gh<_i16.IAuthFacade>());
        return i.checkAuthenticated().then((_) => i);
      },
      preResolve: true,
    );
    return this;
  }
}

class _$RegisterModule extends _i22.RegisterModule {}
