import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../responses/notification_response.dart';

part 'notification_remote_datasource.g.dart';

@RestApi()
abstract class NotificationRemoteDatasource {
  @factoryMethod
  factory NotificationRemoteDatasource(Dio dio, {String baseUrl}) =
      _NotificationRemoteDatasource;

  @GET("/api/v1/notifications")
  Future<NotificationResponse> getNotifications({
    @Query("page") int? page,
    @Query("size") int? size,
  });

  @PUT("/api/v1/notifications/{notificationId}")
  Future<NotificationResponse> updateNotification(
    @Path("notificationId") String notificationId,
  );

  @DELETE("/api/v1/notifications/{notificationId}")
  Future<NotificationResponse> deleteNotification(
    @Path("notificationId") String notificationId,
  );
}
