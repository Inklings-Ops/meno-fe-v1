import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/local_notifications_service.dart';
import 'package:meno/app.dart';
import 'package:meno/firebase_options.dart';
import 'package:meno/global_locator.dart';

Future<void> handleFCMToken() async {
  const storage = FlutterSecureStorage();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await storage.write(key: StorageKeys.fcmToken, value: fcmToken);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotificationsService.setupChannel();
  await LocalNotificationsService.showStatic(message);
}

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureGlobalDependencies();
  configureGlobalExceptionHandler();

  runApp(const MenoApp());
}
