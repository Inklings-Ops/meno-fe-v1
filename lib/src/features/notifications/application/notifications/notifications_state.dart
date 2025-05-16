part of 'notifications_bloc.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.empty() = NotificationsEmpty;
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded(
    Map<NotificationCategory, List<Notification?>> notifications,
  ) = NotificationsLoaded;
  const factory NotificationsState.failure(
    NotificationException exception,
  ) = NotificationsFailure;
}
