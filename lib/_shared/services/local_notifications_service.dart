import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meno/_core/meno_logger.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/notifications/managers/notifications_manager.dart';
import 'package:meno/features/notifications/models/entities/notification_payload.dart';

class LocalNotificationsService with MLogger {
  LocalNotificationsService(this._router);

  final MenoRouter _router;

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _channelReady = false;
  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Meno notification channel',
    importance: Importance.high,
  );

  /// Creates the Android notification channel. Idempotent.
  static Future<void> setupChannel() async {
    if (_channelReady) return;
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
    _channelReady = true;
  }

  /// Shows a notification with no tap-routing capability.
  /// Used only from the background isolate where no router exists.
  static Future<void> showStatic(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification == null || android == null || kIsWeb) return;

    await _plugin.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@drawable/ic_stat_ic_notification',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> initialize() async {
    await setupChannel();

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(
          '@drawable/ic_stat_ic_notification',
        ),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onTap,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Called when the user taps a notification shown by this service
  /// (foreground only — background taps go through [handleBackgroundTap]).
  void _onTap(NotificationResponse response) {
    final payload = NotificationPayload.decode(response.payload);
    if (payload == null) {
      _router.push(R.notifications);
      return;
    }
    // _router.push(NotificationRouter.resolve(payload));
    _router.push(R.notifications);
  }

  /// Used from NotificationsManager for foreground messages.
  /// Encodes deep-link payload so taps can route correctly.
  Future<void> show(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // Build a typed payload from the FCM data map so the tap handler
    // can deep-link correctly.
    final payload = NotificationPayload.fromData(message.data);

    await _plugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@drawable/ic_stat_ic_notification',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload.encode(),
    );
  }

  /// Handle a tap on a background/killed notification (FCM-displayed).
  /// Call this from [NotificationsManager] when `onMessageOpenedApp` fires.
  void handleBackgroundTap(RemoteMessage message) {
    // final payload = NotificationPayload.fromData(message.data);
    // _router.push(NotificationRouter.resolve(payload));
    _router.push(R.notifications);
  }
}

//
// class NotificationRouter {
//   const NotificationRouter._();
//
//   /// Returns the go_router path to push for a given payload.
//   static String resolve(NotificationPayload payload) {
//     return switch (payload.type) {
//       NotificationType.userSubscribed =>
//         payload.userId != null
//             ? '/users/${payload.userId}/profile'
//             : R.notifications,
//
//       // You were added as co-host → go to that broadcast
//       NotificationType.addedAsCoHost =>
//         payload.broadcastId != null
//             ? '/broadcasts/${payload.broadcastId}'
//             : R.notifications,
//
//       // A live broadcast started → go to that broadcast
//       NotificationType.liveBroadcastStarted =>
//         payload.broadcastId != null
//             ? R.preStream(broadcastId)
//             : R.notifications,
//     };
//   }
// }
