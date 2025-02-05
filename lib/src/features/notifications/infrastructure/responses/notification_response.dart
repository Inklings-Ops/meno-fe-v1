import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_response.freezed.dart';
part 'notification_response.g.dart';

@Freezed(genericArgumentFactories: true, toJson: true)
class NotificationResponse<T> with _$NotificationResponse<T> {
  factory NotificationResponse({
    int? statusCode,
    String? message,
    bool? status,
    T? data,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$NotificationResponseFromJson(json, fromJsonT);
}
