import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/exceptions/notification_exception.dart';

abstract class INotificationFacade {
  Future<Either<NotificationException, List<Notification?>>> getNotifications({
    int? page,
    int? size,
  });

  Future<Either<NotificationException, Unit>> updateNotification(String id);

  Future<Either<NotificationException, Unit>> deleteNotification(String id);
}
