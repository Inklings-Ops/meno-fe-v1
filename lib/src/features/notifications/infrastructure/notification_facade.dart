import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/notification_exception.dart';
import 'package:meno_fe_v1/src/core/response/response.dart' show PaginatedList;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';

@Injectable(as: INotificationFacade)
class NotificationFacade implements INotificationFacade {
  NotificationFacade({
    required NotificationRemoteDatasource remoteDatasource,
    required NetworkService networkService,
  })  : _remote = remoteDatasource,
        _network = networkService;
  final NotificationRemoteDatasource _remote;
  final NetworkService _network;

  @override
  Future<Either<NotificationException, PaginatedList<Notification?>>>
      getNotifications({
    int? page,
    int? size,
  }) async {
    if (!(await _network.isConnected)) {
      return const Left(NotificationNetworkException());
    }

    try {
      var sortedList = <NotificationDto?>[];
      final response = await _remote.getNotifications(page: page, size: size);
      final data = response.data!;
      final notifications = data.notifications;
      if (notifications.isNotEmpty) {
        sortedList = notifications.toList()
          ..sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
      }

      final paginatedList = PaginatedList(
        items: sortedList.map((dto) => dto?.toDomain).toList(),
        currentPage: data.currentPage,
        totalItems: data.totalItems,
        totalPages: data.totalPages,
      );

      return Right(paginatedList);
    } on DioException catch (e) {
      return Left(NotificationExceptionWithMessage(e.message ?? 'Error'));
    }
  }

  @override
  Future<Either<NotificationException, Unit>> deleteNotification(
    String id,
  ) async {
    if (!(await _network.isConnected)) {
      return const Left(NotificationNetworkException());
    }

    try {
      await _remote.deleteNotification(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(NotificationExceptionWithMessage(e.message ?? 'Error'));
    }
  }

  @override
  Future<Either<NotificationException, Unit>> updateNotification(
    String id,
  ) async {
    if (!(await _network.isConnected)) {
      return const Left(NotificationNetworkException());
    }

    try {
      await _remote.updateNotification(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(NotificationExceptionWithMessage(e.message ?? 'Error'));
    }
  }
}
