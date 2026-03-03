import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notifications/domain/domain.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/domain/value_objects/paged_list.dart';

class NotificationsManager implements Disposable {
  NotificationsManager(this._repository);

  final INotificationRepository _repository;

  final notifications = ValueNotifier(const PagedList<Notification?>.empty());
  final error = ValueNotifier<MenoException?>(null);
  final _pagination = ValueNotifier(const PaginationParams());

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _repository.getNotifications(_pagination.value);
    result.fold(
      (failure) => throw failure,
      (page) => notifications.value = page,
    );
  }, errorFilterFn: menoExceptionFilter);

  late final fetchMore = Command.createAsyncNoParamNoResult(() async {
    final nextPage = _pagination.value.next();
    final result = await _repository.getNotifications(nextPage);
    result.fold(
      (failure) => error.value = failure,
      (page) => notifications.value.merge(page),
    );
  }, errorFilterFn: menoExceptionFilter);

  late final updateNotification = Command.createAsyncNoResult((
    Notification notification,
  ) async {
    final id = notification.id;
    if (id == null) throw const MenoException('Notification cannot be empty');

    final previousList = List<Notification>.from(notifications.value.items);
    final currentList = previousList;

    final index = currentList.indexWhere((i) => i.id == id);
    if (index == -1) throw const MenoException('Notification does not exist');
    currentList[index] = notification;
    notifications.value = notifications.value.copyWith(items: currentList);

    final result = await _repository.updateNotification(id);
    result.fold((failure) {
      error.value = failure;
      notifications.value = notifications.value.copyWith(items: previousList);
    }, (_) {});
  }, errorFilterFn: menoExceptionFilter);

  late final deleteNotification = Command.createAsyncNoResult((
    String notificationId,
  ) async {
    final previousList = List<Notification>.from(notifications.value.items);
    final currentList = previousList;

    currentList.removeWhere((i) => i.id == notificationId);
    notifications.value = notifications.value.copyWith(items: currentList);

    final result = await _repository.deleteNotification(notificationId);
    result.fold((failure) {
      error.value = failure;
      notifications.value = notifications.value.copyWith(items: previousList);
    }, (_) {});
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    notifications.dispose();
    error.dispose();
    _pagination.dispose();

    fetch.dispose();
    fetchMore.dispose();
  }
}
