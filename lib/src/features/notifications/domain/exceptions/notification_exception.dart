import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_exception.freezed.dart';

@freezed
class NotificationException with _$NotificationException {
  const factory NotificationException.message(String message) = _Message;
  const factory NotificationException.serverError() = _ServerError;
  const factory NotificationException.unknownError() = _UnknownError;
  const factory NotificationException.timeOutError() = _TimeOutError;
  const factory NotificationException.networkError() = _NetworkError;
}
