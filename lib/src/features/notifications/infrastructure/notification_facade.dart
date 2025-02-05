import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';

@LazySingleton(as: INotificationFacade)
class NotificationFacade implements INotificationFacade {
  NotificationFacade({
    required NotificationRemoteDatasource remoteDatasource,
    required NetworkService networkService,
  })  : _remote = remoteDatasource,
        _network = networkService;
  final NotificationRemoteDatasource _remote;
  final NetworkService _network;

  @override
  Future<Either<NotificationException, List<Notification?>>> getNotifications({
    int? page,
    int? size,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const NotificationException.networkError());
    }

    try {
      var sortedList = <Notification?>[];
      final response = await _remote.getNotifications(page: page, size: size);
      final notifications = response.data?.toDomain.notifications;
      if (notifications?.isNotEmpty ?? false) {
        sortedList = notifications!.toList()
          ..sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
      }
      return right(sortedList);
    } on DioException catch (e) {
      return left(NotificationException.message(e.message ?? 'Error'));
    }
  }

  @override
  Future<Either<NotificationException, Unit>> deleteNotification(
    String id,
  ) async {
    if (!(await _network.isConnected)) {
      return left(const NotificationException.networkError());
    }

    try {
      await _remote.deleteNotification(id);
      return right(unit);
    } on DioException catch (e) {
      return left(NotificationException.message(e.message ?? 'Error'));
    }
  }

  @override
  Future<Either<NotificationException, Unit>> updateNotification(
    String id,
  ) async {
    if (!(await _network.isConnected)) {
      return left(const NotificationException.networkError());
    }

    try {
      await _remote.updateNotification(id);
      return right(unit);
    } on DioException catch (e) {
      return left(NotificationException.message(e.message ?? 'Error'));
    }
  }
}
