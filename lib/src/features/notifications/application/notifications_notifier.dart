import 'package:meno_fe_v1/src/features/notifications/application/notification_providers.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_notifier.g.dart';

enum NotificationCategory { today, thisWeek, older, none }

extension NotificationCategoryX on NotificationCategory {
  String get toName => switch (this) {
        NotificationCategory.none => 'None',
        NotificationCategory.today => 'Today',
        NotificationCategory.older => 'Older',
        NotificationCategory.thisWeek => 'This Week',
      };
}

@riverpod
Map<NotificationCategory, List<Notification?>> sortNotifications(
  SortNotificationsRef ref,
) {
  final notifications = ref.watch(notificationsNotifierProvider);

  if (notifications.hasValue && notifications.value!.isNotEmpty) {
    final grouped = <NotificationCategory, List<Notification>>{};
    for (final notification in notifications.value!) {
      final category = getCategory(notification!.createdAt);
      grouped.putIfAbsent(category, () => []).add(notification);
    }
    return grouped;
  } else {
    return {NotificationCategory.none: []};
  }
}

NotificationCategory getCategory(DateTime createdAt) {
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

@Riverpod(keepAlive: true)
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  Future<List<Notification?>> build() async {
    // const AsyncLoading();
    // final res = await ref.read(notificationFacadeProvider).getNotifications();
    // return res.fold((l) => [], (r) => r);
    return [];
  }

  Future<void> getNotifications({int? page, int? size}) async {
    state = const AsyncLoading();
    final res = await ref.read(notificationFacadeProvider).getNotifications();
    state = res.fold(
      (l) => const AsyncData([]),
      AsyncData.new,
    );
  }

  Future<void> deleteNotifications(String id) async {
    await ref.read(notificationFacadeProvider).deleteNotification(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateNotifications(String id) async {
    await ref.read(notificationFacadeProvider).updateNotification(id);
    ref.invalidateSelf();
    await future;
  }
}
