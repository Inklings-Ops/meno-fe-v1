import 'dart:async';

import 'package:meno/core/core.dart';
import 'package:meno/features/notifications/infrastructure/dtos/notification_dto.dart';

class NotificationSocketDataSource {
  const NotificationSocketDataSource(this._client);

  final WebSocketClient _client;

  Stream<NotificationDto> get onNewNotification {
    late final StreamController<NotificationDto> controller;
    SocketSubscription? subscription;
    controller = StreamController<NotificationDto>.broadcast(
      onListen: () {
        subscription = _client.on(SocketEvent.notification, (dynamic data) {
          final notification = NotificationDto.fromJson(data);
          controller.add(notification);
        });
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }
}
