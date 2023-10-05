import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/core/clients/m_clients.dart';
import 'package:meno_fe_v1/core/env/env.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  InternetConnectionChecker get connectionChecker {
    return InternetConnectionChecker.createInstance();
  }

  @lazySingleton
  AuthRemoteDatasource get authRemoteDatasource {
    final dio = MClients.dioClient(Env.menoApiUrl);
    return AuthRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
