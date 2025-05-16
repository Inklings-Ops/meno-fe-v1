import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_remote_datasource.g.dart';

@injectable
@RestApi()
abstract class NotificationRemoteDatasource {
  @factoryMethod
  factory NotificationRemoteDatasource(
    Dio dio, {
    @Named('baseUrl') String baseUrl,
  }) = _NotificationRemoteDatasource;

  @GET('/api/v1/notifications')
  Future<NotificationResponse<NotificationDataDto>> getNotifications({
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @PUT('/api/v1/notifications/{notificationId}')
  Future<NotificationResponse<dynamic>> updateNotification(
    @Path('notificationId') String notificationId,
  );

  @DELETE('/api/v1/notifications/{notificationId}')
  Future<NotificationResponse<dynamic>> deleteNotification(
    @Path('notificationId') String notificationId,
  );
}
