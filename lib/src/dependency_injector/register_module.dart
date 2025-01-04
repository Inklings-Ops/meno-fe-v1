import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/src/core/clients/m_clients.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/objectbox_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  BibleRemoteDatasource get bibleRemoteDatasource {
    return BibleRemoteDatasource(dio, baseUrl: Env.bibleApiUrl);
  }

  @lazySingleton
  ChatRemoteDatasource get chatRemoteDatasource {
    return ChatRemoteDatasource(dio, baseUrl: Env.menoApiUrl);
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
