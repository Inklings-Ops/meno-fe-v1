import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';

import '../router/router.dart';

@Injectable()
class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final SecureStorageService _storageService;
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationService({
    required FirebaseMessaging firebaseMessaging,
    required SecureStorageService storageService,
    required FlutterLocalNotificationsPlugin localNotifications,
  })  : _firebaseMessaging = firebaseMessaging,
        _storageService = storageService,
        _localNotifications = localNotifications;

  @PostConstruct(preResolve: true)
  Future initialize() async {
    // await getToken();
    // await _firebaseMessaging.requestPermission();
    // await initPushNotifications();
    // // await initLocalNotifications();
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handleMessage(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    // FirebaseMessaging.onMessage.listen((event) {
    //   final notification = event.notification;
    //   if (notification != null) {
    //     _localNotifications.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           _androidChannel.id,
    //           _androidChannel.name,
    //           channelDescription: _androidChannel.description,
    //           icon: "@drawable/ic_launcher",
    //         ),
    //       ),
    //       payload: jsonEncode(event.toMap()),
    //     );
    //   }
    // });
  }

  Future<String?> getToken() async {
    final token = await _firebaseMessaging.getToken();
    Logger().w("Firebase Token: $token");
    await _storageService.write(MKeys.fcmToken, value: token);
    return token;
  }

  Future<void> backgroundHandler([RemoteMessage? message]) async {
    Logger().i('Message ID ${message?.messageId}');
    Logger().i('Message title ${message?.notification?.title}');
    Logger().i('Message body ${message?.notification?.body}');
    Logger().i('Payload ${message?.data}');
  }

  void handleMessage([RemoteMessage? message]) {
    if (message == null) return;
    GoRouter.maybeOf(rootNavigatorKey.currentContext!)?.pushNamed(
      Routes.notifications,
      extra: message,
    );
  }

  // Local Notifications
  final _androidChannel = const AndroidNotificationChannel(
    "meno_notification_channel",
    "Meno",
    description: "Meno Notification",
    importance: Importance.defaultImportance,
  );
}
