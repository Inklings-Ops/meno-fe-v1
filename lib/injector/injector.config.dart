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

import '../features/auth/domain/domain.dart' as _i7;
import '../features/auth/infrastructure/auth_facade.dart' as _i8;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i6;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../services/secure_storage_service.dart' as _i5;
import 'resgister_module.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.AuthMapper>(_i3.AuthMapper());
    gh.lazySingleton<_i4.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.lazySingleton<_i5.SecureStorageService>(
        () => _i5.SecureStorageService());
    gh.factory<_i6.AuthLocalDatasource>(
        () => _i6.AuthLocalDatasource(storage: gh<_i5.SecureStorageService>()));
    gh.lazySingleton<_i7.IAuthFacade>(() => _i8.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i6.AuthLocalDatasource>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
