import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/core/clients/m_clients.dart';
import 'package:meno_fe_v1/core/env/env.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_remote_datasource.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  AuthRemoteDatasource get authRemoteDatasource {
    final dio = MClients.dioClient(Env.menoApiUrl);
    return AuthRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }
}
