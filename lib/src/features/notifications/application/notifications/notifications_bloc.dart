import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

enum NotificationCategory { today, thisWeek, older, none }

extension NotificationCategoryX on NotificationCategory {
  String get toName => switch (this) {
        NotificationCategory.none => 'None',
        NotificationCategory.today => 'Today',
        NotificationCategory.older => 'Older',
        NotificationCategory.thisWeek => 'This Week',
      };
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({
    required INotificationFacade facade,
  })  : _facade = facade,
        super(const NotificationsLoadEmpty()) {
    on<NotificationsFetchRequested>(_onGetNotifications);
    on<NotificationsDeleteRequested>(_onDelete);
    on<NotificationsUpdateRequested>(_onUpdate);
  }

  final INotificationFacade _facade;

  Future<void> _onGetNotifications(
    NotificationsFetchRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoadInProgress());
    final res = await _facade.getNotifications(page: 1, size: 50);
    emit(
      res.fold(
        NotificationsLoadFailed.new,
        (paginatedList) {
          final notifications = paginatedList.items;
          if (notifications.isEmpty) return const NotificationsLoadEmpty();
          final sortedNotifications = _sortNotifications(notifications);
          return NotificationsLoadSuccess(sortedNotifications);
        },
      ),
    );
  }

  Future<void> _onDelete(
    NotificationsDeleteRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoadInProgress());
    final fOrS = await _facade.deleteNotification(event.id);
    fOrS.fold(
      (exception) => emit(NotificationsLoadFailed(exception)),
      (_) {
        if (state is NotificationsLoadSuccess) {
          final list = (state as NotificationsLoadSuccess).notifications;
          final updatedList =
              Map<NotificationCategory, List<Notification?>>.from(list);
          updatedList.removeWhere((key, v) => v.any((e) => e?.id == event.id));
          emit(NotificationsLoadSuccess(updatedList));
        }
      },
    );
  }

  Future<void> _onUpdate(
    NotificationsUpdateRequested event,
    Emitter<NotificationsState> emit,
  ) async {}

  Map<NotificationCategory, List<Notification>> _sortNotifications(
    List<Notification?> notifications,
  ) {
    if (notifications.isNotEmpty) {
      final grouped = <NotificationCategory, List<Notification>>{};
      for (final notification in notifications) {
        final category = _getCategory(notification!.createdAt!);
        grouped.putIfAbsent(category, () => []).add(notification);
      }
      return grouped;
    } else {
      return {NotificationCategory.none: []};
    }
  }

  NotificationCategory _getCategory(DateTime createdAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    if (createdAt.isAfter(today)) {
      return NotificationCategory.today;
    } else if (createdAt.isAfter(thisWeekStart)) {
      return NotificationCategory.thisWeek;
    } else {
      return NotificationCategory.older;
    }
  }
}
