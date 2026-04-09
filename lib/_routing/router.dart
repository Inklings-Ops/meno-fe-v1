import 'package:flutter/material.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';
import 'package:meno/features/onboarding/manager/onboarding_manager.dart';

final class MenoRouter {
  MenoRouter._({
    required Listenable refreshListenable,
    required RouterGuard guard,
  }) : config = _buildRouter(refreshListenable, guard);

  /// Creates the singleton. Called exactly once from the global locator.
  ///
  /// Dependencies are passed explicitly — no DI calls inside this class.
  factory MenoRouter.create(AuthManager auth, OnboardingManager onboarding) {
    assert(_instance == null, 'MenoRouter.create() called more than once.');

    final refreshListenable = Listenable.merge([
      onboarding.isOnboarded,
      auth.activeUserId,
      auth.emailVerified,
    ]);

    return _instance = MenoRouter._(
      refreshListenable: refreshListenable,
      guard: RouterGuard(auth: auth, onboarding: onboarding),
    );
  }

  /// MenoRouter singleton
  static MenoRouter? _instance;

  /// The single live instance. Available after [MenoRouter.create] has
  /// been called.
  static MenoRouter get instance {
    assert(_instance != null, 'MenoRouter accessed before it was created.');
    return _instance!;
  }

  /// The [GoRouter] configuration access
  final GoRouter config;

  /// The current matched URI. No DI or BuildContext required.
  String get currentLocation {
    final last = config.routerDelegate.currentConfiguration.last;
    final matchList = last is ImperativeRouteMatch
        ? last.matches
        : config.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  /// Convenience navigation forwarders for use outside widget trees.
  void go(String route, {Object? extra}) => config.go(route, extra: extra);

  /// Convenience navigation forwarders for use outside widget trees.
  void push(String route, {Object? extra}) => config.push(route, extra: extra);

  /// Convenience navigation forwarders for use outside widget trees.
  void pop() => config.routerDelegate.navigatorKey.currentState?.pop();

  /// Convenience navigation forwarders for use outside widget trees.
  Future<T?> replace<T>(String route, {Object? extra}) {
    return config.replace<T?>(route, extra: extra);
  }

  ///  Router definition and assembly
  static GoRouter _buildRouter(
    Listenable refreshListenable,
    RouterGuard guard,
  ) {
    return GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: RouterKeys.root,
      initialLocation: R.home,
      refreshListenable: refreshListenable,
      redirect: guard.call,
      routes: [
        ...StandaloneRoutes.routes,
        ...AuthRoutes.routes,
        ...SettingsRoutes.routes,
        ...ModalRoutes.routes,
        LiveShellRoutes.shell,
        MainShellRoutes.shell,
      ],
    );
  }
}

extension MenoRouterExtensions on BuildContext {
  /// Pops the [BuildContext] [count] number of times.
  ///
  /// For example, to pop twice: context.popCount(2);
  void popCount(int count) {
    var popped = 0;
    Navigator.of(this).popUntil((_) => popped++ >= count);
  }

  /// Alias for semantic clarity if you prefer "pop multiple"
  void popMultiple(int count) => popCount(count);

  void popUntil(String targetPathName) {
    return Navigator.of(
      this,
    ).popUntil((r) => r.settings.name == targetPathName);
  }
}
