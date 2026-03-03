import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notifications/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

abstract interface class INotificationRepository {
  Future<Either<MenoException, PagedList<Notification?>>> getNotifications([
    PaginationParams params = const PaginationParams(),
  ]);

  Future<Either<MenoException, Unit>> updateNotification(String notificationId);

  Future<Either<MenoException, Unit>> deleteNotification(String notificationId);
}
