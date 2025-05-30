part of 'notifications_bloc.dart';

sealed class NotificationsState with EquatableMixin {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoadEmpty extends NotificationsState {
  const NotificationsLoadEmpty();
}

final class NotificationsLoadInProgress extends NotificationsState {
  const NotificationsLoadInProgress();
}

final class NotificationsLoadSuccess extends NotificationsState {
  const NotificationsLoadSuccess(this.notifications);
  final Map<NotificationCategory, List<Notification?>> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsLoadFailed extends NotificationsState {
  const NotificationsLoadFailed(this.exception);
  final NotificationException exception;

  @override
  List<Object?> get props => [exception];
}
