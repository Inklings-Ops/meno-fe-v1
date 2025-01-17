import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/secure_storage_service.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Meno notification channel',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  final notification = message.notification;
  final android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/ic_stat_ic_notification',
        ),
      ),
    );
  }
}

void openNotifications(RemoteMessage message) {
  router.push(Routes.notifications);
}

Future<void> handleFCMToken() async {
  const storage = FlutterSecureStorage();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await storage.write(key: MKeys.fcmToken, value: fcmToken);
}

@Injectable()
class NotificationService {
  NotificationService({
    required FirebaseMessaging firebaseMessaging,
    required SecureStorageService storageService,
  })  : _firebaseMessaging = firebaseMessaging,
        _storageService = storageService;
  final FirebaseMessaging _firebaseMessaging;
  final SecureStorageService _storageService;

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(provisional: true);
  }

  Future<String?> get fcmToken => _firebaseMessaging.getToken();

  Future<void> storeToken() async {
    final token = await _firebaseMessaging.getToken();
    await _storageService.write(MKeys.fcmToken, value: token);
  }
}
