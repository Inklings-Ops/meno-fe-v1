import 'dart:async';

import 'package:meno/_core/meno_logger.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notifications/models/_models.dart';

class NotificationsSocketService with MLogger {
  NotificationsSocketService(this._client);

  final SocketClient _client;

  Stream<Notification> get onNewNotification {
    late StreamController<Notification> controller;
    SocketSubscription? subscription;

    controller = StreamController<Notification>.broadcast(
      onListen: () {
        subscription = _client.on(.notification, (data) {
          log.e('NotificationsSocketService: $data');
          final dto = NotificationDto.fromJson(data);
          controller.add(dto.toDomain);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }
}
