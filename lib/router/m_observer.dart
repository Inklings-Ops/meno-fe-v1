import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MObserver extends AutoRouterObserver {
  final Logger _log = Logger();

  String? previousRoutePath;

  @override
  void didPush(Route route, Route? previousRoute) {
    previousRoutePath = previousRoute?.data?.path;

    _log.i('New route pushed: ${route.settings.name}');
    _log.e(previousRoutePath);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _log.i('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _log.i('Tab route re-visited: ${route.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _log.i("${route.settings.name} popped");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _log.i("${oldRoute?.settings.name} replaced by ${newRoute?.settings.name}");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _log.i("${route.settings.name} removed");
  }
}
