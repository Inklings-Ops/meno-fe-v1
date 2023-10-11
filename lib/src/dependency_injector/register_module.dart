import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/clients/m_clients.dart';
import '../core/env/env.dart';
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart';

final Dio dio = MClients.dioClient(Env.menoApiUrl);

@module
abstract class RegisterModule {
  @lazySingleton
  InternetConnectionChecker get connectionChecker {
    return InternetConnectionChecker.createInstance();
  }

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  AuthRemoteDatasource get authRemoteDatasource {
    return AuthRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @lazySingleton
  BroadcastRemoteDatasource get broadcastRemoteDatasource {
    return BroadcastRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
