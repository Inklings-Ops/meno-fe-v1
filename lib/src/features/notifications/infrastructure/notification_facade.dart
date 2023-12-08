import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../services/network_service.dart';
import '../domain/entities/notification.dart';
import '../domain/exceptions/notification_exception.dart';
import '../domain/i_notification_facade.dart';
import 'datasources/notification_remote_datasource.dart';
import 'mapper/notifications_mapper.dart';

@LazySingleton(as: INotificationFacade)
class NotificationFacade implements INotificationFacade {
  final NotificationRemoteDatasource _remote;
  final NetworkService _network;

  NotificationFacade({
    required NotificationRemoteDatasource remoteDatasource,
    required NetworkService networkService,
  })  : _remote = remoteDatasource,
        _network = networkService;

  final _mapper = NotificationsMapper();

  @override
  Future<Either<NotificationException, List<Notification?>>> getNotifications({
    int? page,
    int? size,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const NotificationException.networkError());
    }

    try {
      final response = await _remote.getNotifications(page: page, size: size);
      final list = _mapper.dataToDomain(response.data)!.notifications;
      return right(list);
    } on DioException catch (e) {
      return left(NotificationException.message(e.message ?? "Error"));
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
      return left(NotificationException.message(e.message ?? "Error"));
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
      return left(NotificationException.message(e.message ?? "Error"));
    }
  }
}
