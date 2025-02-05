part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.getNotifications() = GetNotifications;
  const factory NotificationsEvent.delete(String id) = DeleteNotification;
  const factory NotificationsEvent.update(String id) = UpdateNotification;
}
