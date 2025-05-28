import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/src/core/clients/m_clients.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/services/objectbox_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  String get baseUrl => Env.menoApiUrl;

  @Named('bibleUrl')
  String get bibleUrl => Env.bibleApiUrl;

  @lazySingleton
  Dio dio(@Named('baseUrl') String baseUrl, AuthTokenInterceptor interceptor) {
    final dio = Dio()..options = BaseOptions(baseUrl: baseUrl);
    dio.interceptors.addAll([
      // LogInterceptor(
      //   requestBody: true,
      //   responseBody: true,
      //   responseHeader: false,
      // ),
      interceptor,
    ]);
    return dio;
  }

  @lazySingleton
  InternetConnectionChecker get internetChecker =>
      InternetConnectionChecker.instance;

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

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
