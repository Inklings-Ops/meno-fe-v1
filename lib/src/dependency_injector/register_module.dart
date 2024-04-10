import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/clients/m_clients.dart';
import '../core/env/env.dart';
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart';
import '../features/notes/infrastructure/datasources/note_remote_datasource.dart';
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart';
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart';
import '../services/objectbox_service.dart';

final Dio dio = MClients.dioClient(Env.menoApiUrl);

@module
abstract class RegisterModule {
  @lazySingleton
  AuthRemoteDatasource get authRemoteDatasource {
    return AuthRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @lazySingleton
  BroadcastRemoteDatasource get broadcastRemoteDatasource {
    return BroadcastRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @lazySingleton
  NotificationRemoteDatasource get notificationRemoteDatasource {
    return NotificationRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @lazySingleton
  NoteRemoteDatasource get noteRemoteDatasource {
    return NoteRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @lazySingleton
  InternetConnectionChecker get internetChecker => InternetConnectionChecker();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  ProfileRemoteDatasource get profileRemoteDatasource {
    return ProfileRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
  }

  @lazySingleton
  FirebaseMessaging get fcm => FirebaseMessaging.instance;

  @lazySingleton
  FlutterLocalNotificationsPlugin get localNotifications =>
      FlutterLocalNotificationsPlugin();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  @preResolve
  Future<ObjectBoxService> get obj => ObjectBoxService.create();
}
