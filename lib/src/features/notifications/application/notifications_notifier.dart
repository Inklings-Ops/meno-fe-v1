import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/notification.dart';
import 'notification_providers.dart';

part "notifications_notifier.g.dart";

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  Future<List<Notification?>> build() async => [];

  Future<void> getNotifications({int? page, int? size}) async {
    state = const AsyncLoading();
    final response =
        await ref.read(notificationFacadeProvider).getNotifications();
    state = response.fold(
      (l) => AsyncError(l, StackTrace.current),
      (r) => AsyncData(r),
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
