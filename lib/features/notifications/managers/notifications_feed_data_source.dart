import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno/features/notifications/services/_services.dart';

class NotificationsFeedSource extends PagedFeedDataSource<NotificationProxy> {
  NotificationsFeedSource({required NotificationsHttpService http})
    : _http = http;

  final NotificationsHttpService _http;

  final _proxyCache = <String, NotificationProxy>{};

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

  @override
  FutureOr<dynamic> onDispose() {
    for (final proxy in _proxyCache.values) {
      proxy.dispose();
    }
    _proxyCache.clear();
    return super.onDispose();
  }
}
