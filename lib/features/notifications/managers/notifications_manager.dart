import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/meno_logger.dart';
import 'package:meno/_shared/services/_services.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno/features/notifications/services/_services.dart';

class NotificationsManager with MLogger implements Disposable {
  NotificationsManager({
    required NotificationsSocketService socket,
    required PushNotificationsService pushService,
    required LocalNotificationsService localNotifications,
  }) : _socket = socket,
       _pushService = pushService,
       _localNotifications = localNotifications;

  final NotificationsSocketService _socket;
  final PushNotificationsService _pushService;
  final LocalNotificationsService _localNotifications;

  final unreadCount = ValueNotifier<int>(0);
  final fcmToken = ValueNotifier<String?>(null);

  final newNotificationCount = ValueNotifier<int>(0);
  final recentNotifications = ValueNotifier<List<Notification>>([]);

  StreamSubscription<Notification>? _notificationSubscription;
  StreamSubscription<dynamic>? _pushNotificationSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _backgroundTapSubscription;

  Timer? _dismissTimer;

  Future<void> init() async {
    // Load current token into state (for debugging/display if needed)
    fcmToken.value = await _pushService.getToken();

    // Token rotation
    _tokenRefreshSubscription = _pushService.onTokenRefresh.listen((token) {
      fcmToken.value = token;
    });

    // Foreground FCM → show system tray notification
    _pushNotificationSubscription = _pushService.onMessage.listen(
      _localNotifications.show,
    );

    // Background tap → deep-link
    _backgroundTapSubscription = _pushService.onMessageOpenedApp.listen(
      _localNotifications.handleBackgroundTap,
    );

    // Killed-state tap → deep-link 👈 add
    final initial = await _pushService.getInitialMessage();
    if (initial != null) _localNotifications.handleBackgroundTap(initial);

    _notificationSubscription = _socket.onNewNotification.listen((incoming) {
      unreadCount.value++;
      newNotificationCount.value++;

      recentNotifications.value = [
        incoming,
        ...recentNotifications.value,
      ].take(3).toList();

      _dismissTimer?.cancel();
      _dismissTimer = Timer(const Duration(seconds: 4), dismissToasts);
    });
  }

  void dismissToasts() => recentNotifications.value = [];

  void resetNewCount() => newNotificationCount.value = 0;

  @override
  FutureOr<dynamic> onDispose() async {
    await _notificationSubscription?.cancel();
    await _pushNotificationSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    await _backgroundTapSubscription?.cancel();

    _notificationSubscription = null;
    _pushNotificationSubscription = null;
    _tokenRefreshSubscription = null;
    _backgroundTapSubscription = null;

    unreadCount.dispose();

    _dismissTimer?.cancel();
    _dismissTimer = null;

    newNotificationCount.dispose();
    recentNotifications.dispose();
  }
}
