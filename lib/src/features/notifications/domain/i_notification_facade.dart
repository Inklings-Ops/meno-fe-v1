import 'package:dartz/dartz.dart';

import 'entities/notification.dart';
import 'exceptions/notification_exception.dart';

abstract class INotificationFacade {
  Future<Either<NotificationException, List<Notification?>>> getNotifications({
    int? page,
    int? size,
  });

  Future<Either<NotificationException, Unit>> updateNotification(String id);

  Future<Either<NotificationException, Unit>> deleteNotification(String id);
}
