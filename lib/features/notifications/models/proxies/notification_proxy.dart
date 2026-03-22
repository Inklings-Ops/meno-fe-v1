import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno/features/notifications/services/_services.dart';

final class NotificationProxy extends ChangeNotifier implements Disposable {
  NotificationProxy(this._notification);

  Notification _notification;
  bool? _isReadOverride;

  Notification get notification => _notification;

  bool get isRead => _isReadOverride ?? _notification.read;

  set notification(Notification value) {
    _isReadOverride = null;
    _notification = value;
    notifyListeners();
  }

  late final markAsRead = Command.createUndoableNoParamNoResult<bool>(
    (stack) async {
      final id = _notification.id;
      if (id == null) return;

      stack.push(isRead);
      _isReadOverride = !isRead;
      notifyListeners();

      await di<NotificationsHttpService>().updateNotification(id);
    },
    undo: (stack, reason) {
      _isReadOverride = stack.pop();
      notifyListeners();
    },
  );

  late final delete = Command.createUndoableNoParamNoResult<Notification>(
    (stack) async {
      final id = _notification.id;
      if (id == null) return;

      stack.push(_notification);
      await di<NotificationsHttpService>().deleteNotification(id);
    },
    undo: (stack, reason) {
      stack.pop();
    },
  );

  @override
  FutureOr<dynamic> onDispose() {
    markAsRead.dispose();
    super.dispose();
  }
}
