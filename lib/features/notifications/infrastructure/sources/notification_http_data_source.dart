import 'package:dio/dio.dart';
import 'package:meno/core/core.dart';

class NotificationHttpDataSource {
  const NotificationHttpDataSource(this._client);

  final ApiClient _client;

  Future<dynamic> getNotifications(
    Map<String, dynamic> params, {
    CancelToken? cancelToken,
  }) {
    return _client.get(
      '/notifications',
      queryParameters: params,
      fromJson: (json) => json,
      cancelToken: cancelToken,
    );
  }

  Future<void> updateNotification(String notificationId) {
    return _client.putUnit('/notifications/$notificationId');
  }

  Future<void> deleteNotification(String notificationId) {
    return _client.deleteUnit('/notifications/$notificationId');
  }
}
