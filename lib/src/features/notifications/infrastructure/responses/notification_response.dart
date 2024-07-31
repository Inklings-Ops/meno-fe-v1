import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notifications/infrastructure/dtos/notification_data_dto.dart';

part 'notification_response.freezed.dart';
part 'notification_response.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationResponse with _$NotificationResponse {
  factory NotificationResponse({
    int? statusCode,
    String? message,
    bool? status,
    NotificationDataDto? data,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}
