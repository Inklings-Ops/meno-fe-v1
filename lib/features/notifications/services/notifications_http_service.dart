import 'package:dio/dio.dart' show CancelToken;
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notifications/models/_models.dart';

class NotificationsHttpService {
  NotificationsHttpService(this._client);

  final HttpClient _client;

  Future<PagedList<Notification>> getNotifications({
    PaginationParams pagination = const PaginationParams(),
    CancelToken? cancelToken,
  }) async {
    return _client.get(
      '/notifications',
      queryParameters: {'page': pagination.page, 'size': pagination.size},
      fromJson: (json) => PagedList.fromJson(
        json,
        (jsonT) => NotificationDto.fromJson(jsonT).toDomain,
        listKey: 'notifications',
      ),
      cancelToken: cancelToken,
    );
  }

  Future<void> deleteNotification(String id, {CancelToken? cancelToken}) async {
    return _client.deleteUnit('/notifications/$id', cancelToken: cancelToken);
  }

  Future<void> updateNotification(String id, {CancelToken? cancelToken}) async {
    return _client.putUnit('/notifications/$id', cancelToken: cancelToken);
  }
}
