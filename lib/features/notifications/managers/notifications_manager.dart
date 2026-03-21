import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno/features/notifications/services/_services.dart';

class NotificationsManager implements Disposable {
  NotificationsManager(this._socket);

  final NotificationsSocketService _socket;

  final unreadCount = ValueNotifier<int>(0);
  final newNotificationCount = ValueNotifier<int>(0);
  final recentNotifications = ValueNotifier<List<Notification>>([]);

  StreamSubscription<Notification>? _subscription;

  Timer? _dismissTimer;

  Future<void> init() async {
    _subscription = _socket.onNewNotification.listen((notification) {
      unreadCount.value++;
      newNotificationCount.value++;

      recentNotifications.value = [
        notification,
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
    await _subscription?.cancel();
    unreadCount.dispose();

    _dismissTimer?.cancel();
    _dismissTimer = null;

    newNotificationCount.dispose();
    recentNotifications.dispose();
  }
}
