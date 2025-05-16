import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';
part 'notifications_bloc.freezed.dart';

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
        super(const NotificationsEmpty()) {
    on<GetNotifications>(_onGetNotifications);
    on<DeleteNotification>(_onDelete);
    on<UpdateNotification>(_onUpdate);
  }

  final INotificationFacade _facade;

  Future<void> _onGetNotifications(
    GetNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    final res = await _facade.getNotifications(page: 1, size: 50);
    emit(
      res.fold(
        NotificationsFailure.new,
        (notifications) {
          if (notifications.isEmpty) return const NotificationsEmpty();
          final sortedNotifications = _sortNotifications(notifications);
          return NotificationsLoaded(sortedNotifications);
        },
      ),
    );
  }

  Future<void> _onDelete(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    final fOrS = await _facade.deleteNotification(event.id);
    fOrS.fold(
      (exception) => emit(NotificationsFailure(exception)),
      (notifications) {
        if (state is NotificationsLoaded) {
          final list = (state as NotificationsLoaded).notifications;
          final updatedList =
              Map<NotificationCategory, List<Notification?>>.from(list);
          updatedList.removeWhere((key, v) => v.any((e) => e?.id == event.id));
          emit(NotificationsLoaded(updatedList));
        }
      },
    );
  }

  Future<void> _onUpdate(
    UpdateNotification event,
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
