import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/core/response/response.dart' show PaginatedList;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

abstract class INotificationFacade {
  Future<Either<NotificationException, PaginatedList<Notification?>>>
      getNotifications({int? page, int? size});

  Future<Either<NotificationException, Unit>> updateNotification(String id);

  Future<Either<NotificationException, Unit>> deleteNotification(String id);
}
