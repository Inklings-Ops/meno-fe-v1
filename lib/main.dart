import 'dart:async';
import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:meno_fe_v1/app/app.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/services.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    FirebaseMessaging.instance.requestPermission(),
    handleFCMToken(),
    setupFlutterNotifications(),
  ]);
  showFlutterNotification(message);
  log('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await setupFlutterNotifications();
  await configureDependencies();
  // Bloc.observer = MenoBlocObserver(log: Logger());

  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => const MenoBlocProvider(child: MenoApp()),
    ),
  );
}
