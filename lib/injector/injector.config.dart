// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i9;

import '../features/auth/application/auth/auth_notifier.dart' as _i16;
import '../features/auth/application/login/login_notifier.dart' as _i13;
import '../features/auth/application/return_login/return_login_notifier.dart'
    as _i15;
import '../features/auth/domain/domain.dart' as _i11;
import '../features/auth/infrastructure/auth_facade.dart' as _i12;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i10;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i14;
import '../services/jwt_service.dart' as _i6;
import '../services/network_service.dart' as _i7;
import '../services/secure_storage_service.dart' as _i8;
import 'register_module.dart' as _i17;

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
    gh.lazySingleton<_i5.InternetConnectionChecker>(
        () => registerModule.connectionChecker);
    gh.lazySingleton<_i6.JWTService>(() => _i6.JWTService());
    gh.factory<_i7.NetworkService>(
        () => _i7.NetworkService(gh<_i5.InternetConnectionChecker>()));
    gh.lazySingleton<_i8.SecureStorageService>(
        () => _i8.SecureStorageService());
    await gh.factoryAsync<_i9.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i10.AuthLocalDatasource>(() =>
        _i10.AuthLocalDatasource(storage: gh<_i8.SecureStorageService>()));
    gh.lazySingleton<_i11.IAuthFacade>(() => _i12.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i10.AuthLocalDatasource>(),
          networkService: gh<_i7.NetworkService>(),
          jwtService: gh<_i6.JWTService>(),
        ));
    gh.lazySingleton<_i13.LoginNotifier>(
        () => _i13.LoginNotifier(gh<_i11.IAuthFacade>()));
    gh.factory<_i14.OnboardingLocalDatasource>(() =>
        _i14.OnboardingLocalDatasource(storage: gh<_i9.SharedPreferences>()));
    gh.lazySingleton<_i15.ReturnLoginNotifier>(
        () => _i15.ReturnLoginNotifier(gh<_i11.IAuthFacade>()));
    await gh.factoryAsync<_i16.AuthNotifier>(
      () {
        final i = _i16.AuthNotifier(facade: gh<_i11.IAuthFacade>());
        return i.checkAuthenticated().then((_) => i);
      },
      preResolve: true,
    );
    return this;
  }
}

class _$RegisterModule extends _i17.RegisterModule {}
