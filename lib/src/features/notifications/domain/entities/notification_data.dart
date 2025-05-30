import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

final class NotificationData with EquatableMixin {
  const NotificationData({
    required this.notifications,
    required this.totalPages,
    required this.currentPage,
    required this.totalItems,
  });

  final List<Notification?> notifications;
  final int totalPages;
  final int currentPage;
  final int totalItems;
  NotificationData copyWith({
    List<Notification?>? notifications,
    int? totalPages,
    int? currentPage,
    int? totalItems,
  }) {
    return NotificationData(
      notifications: notifications ?? this.notifications,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        totalPages,
        currentPage,
        totalItems,
      ];
}
