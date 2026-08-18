import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno/features/notifications/services/_services.dart';

class NotificationsFeedSource extends PagedFeedDataSource<NotificationProxy> {
  NotificationsFeedSource(this._http);

  final NotificationsHttpService _http;

  final _proxyCache = <String, NotificationProxy>{};
  final groupedItems = ValueNotifier<List<NotificationListItem>>([]);

  @override
  void refreshItemCount() {
    super.refreshItemCount();
    groupedItems.value = _buildGrouped();
  }

  @override
  bool itemsAreEqual(NotificationProxy item1, NotificationProxy item2) {
    return item1.notification.id == item2.notification.id;
  }

  @override
  Future<void> requestNextPage() async {
    if (!hasNextPage) return;

    final result = await _http.getNotifications(
      pagination: PaginationParams(page: nextPageIndex),
    );

    final proxies = result.items
        .where((n) => n.id != null)
        .map(_proxyFor)
        .toList();

    items.addAll(proxies);

    updatePaginationState(
      currentPage: result.currentPage,
      totalPages: result.totalPages,
    );
  }

  @override
  Future<void> updateFeedData() async {
    reset();

    final result = await _http.getNotifications();

    updatePaginationState(
      currentPage: result.currentPage,
      totalPages: result.totalPages,
    );

    final oldItems = List<NotificationProxy>.from(items);
    items.clear();

    final proxies = result.items
        .where((n) => n.id != null)
        .map(_proxyFor)
        .toList();

    items.addAll(proxies);

    // Dispose proxies no longer in the list after animations
    Future.delayed(const Duration(milliseconds: 400), () {
      final activeIds = items.map((p) => p.notification.id).toSet();
      for (final old in oldItems) {
        if (!activeIds.contains(old.notification.id)) {
          _proxyCache.remove(old.notification.id);
          old.dispose();
        }
      }
    });

    updatePaginationState(
      currentPage: result.currentPage,
      totalPages: result.totalPages,
    );
  }

  NotificationProxy _proxyFor(Notification notification) {
    final id = notification.id!;
    if (_proxyCache.containsKey(id)) return _proxyCache[id]!;

    final proxy = NotificationProxy(notification);

    proxy.delete.listen((_, __) {
      removeObject(proxy);
      _proxyCache.remove(id);
    });

    _proxyCache[id] = proxy;
    return proxy;
  }

  List<NotificationListItem> _buildGrouped() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));

    final currentItems = [...items];
    currentItems.sort((a, b) {
      final aDate = a.notification.createdAt ?? DateTime(0);
      final bDate = b.notification.createdAt ?? DateTime(0);
      return bDate.compareTo(aDate);
    });

    final todayItems = <NotificationProxy>[];
    final thisWeekItems = <NotificationProxy>[];
    final olderItems = <NotificationProxy>[];

    for (final proxy in currentItems) {
      final date = proxy.notification.createdAt ?? DateTime(0);
      final day = DateTime(date.year, date.month, date.day);

      if (!day.isBefore(today)) {
        todayItems.add(proxy);
      } else if (!day.isBefore(weekAgo)) {
        thisWeekItems.add(proxy);
      } else {
        olderItems.add(proxy);
      }
    }

    return [
      if (todayItems.isNotEmpty) ...[
        const NotificationSectionHeader('Today'),
        ...todayItems.map(NotificationListEntry.new),
      ],
      if (thisWeekItems.isNotEmpty) ...[
        const NotificationSectionHeader('This week'),
        ...thisWeekItems.map(NotificationListEntry.new),
      ],
      if (olderItems.isNotEmpty) ...[
        const NotificationSectionHeader('Older'),
        ...olderItems.map(NotificationListEntry.new),
      ],
    ];
  }

  @override
  FutureOr<dynamic> onDispose() {
    groupedItems.dispose();
    for (final proxy in _proxyCache.values) {
      proxy.dispose();
    }
    _proxyCache.clear();
    return super.onDispose();
  }
}
