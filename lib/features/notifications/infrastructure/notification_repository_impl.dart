import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notifications/domain/domain.dart';
import 'package:meno/features/notifications/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  const NotificationRepositoryImpl(this._http);

  final NotificationHttpDataSource _http;

  @override
  Future<Either<MenoException, PagedList<Notification?>>> getNotifications([
    PaginationParams params = const PaginationParams(),
  ]) async {
    try {
      final queryParams = {'page': params.page, 'size': params.size};
      final response = await _http.getNotifications(queryParams);

      final json = response as Map<String, dynamic>;

      final items = json['notifications'] as List<dynamic>;
      final currentPage = json['currentPage'] as int;
      final totalItems = json['totalItems'] as int;
      final totalPages = json['totalPages'] as int;

      final sanitizedResponse = PagedList<Notification?>(
        items: items.isNotEmpty
            ? items.map((e) => NotificationDto.fromJson(e).toDomain).toList()
            : const [],
        currentPage: currentPage,
        totalItems: totalItems,
        totalPages: totalPages,
      );

      return Right(sanitizedResponse);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await _http.deleteNotification(notificationId);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> updateNotification(
    String notificationId,
  ) async {
    try {
      await _http.updateNotification(notificationId);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }
}
