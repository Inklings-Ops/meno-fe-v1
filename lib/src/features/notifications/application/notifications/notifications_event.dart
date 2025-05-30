part of 'notifications_bloc.dart';

sealed class NotificationsEvent with EquatableMixin {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

final class NotificationsFetchRequested extends NotificationsEvent {
  const NotificationsFetchRequested();
}

final class NotificationsDeleteRequested extends NotificationsEvent {
  const NotificationsDeleteRequested(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

final class NotificationsUpdateRequested extends NotificationsEvent {
  const NotificationsUpdateRequested(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
