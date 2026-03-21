import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';
import 'package:meno/features/notifications/widgets/notification_toast_stack.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RootShell extends WatchingWidget {
  const RootShell._({
    required this.navigationShell,
    required this.currentRoute,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => RootShell._(
    key: const ValueKey<String>('RootShell'),
    navigationShell: navigationShell,
    currentRoute: state.path,
  );

  final StatefulNavigationShell navigationShell;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final futureNotifier = createOnce(
      () => ValueNotifier<Future<void>>(
        di.allReady(timeout: const Duration(seconds: 30)),
      ),
    );

    final snapshot = watchFuture<ValueNotifier<Future<void>>, void>(
      (n) => n.value,
      target: futureNotifier,
      initialValue: null,
      allowFutureChange: true,
    );

    // Watch userId unconditionally — ordering rule requires all watch* calls
    // to run on every build, regardless of the snapshot state.
    final userId = watchValue((AuthManager m) => m.activeUserId);

    if (snapshot.hasError) {
      return MenoErrorWidget(
        error: snapshot.error,
        onRetry: () async {
          futureNotifier.value = di.allReady(
            timeout: const Duration(seconds: 30),
          );
        },
      );
    }

    if (snapshot.connectionState == .waiting) return const LoadingPage();

    final index = navigationShell.currentIndex;
    final useSideNavRail = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    Widget sideNavRail = const SizedBox.shrink();
    Widget? bottomNavBar = BottomNavBar(selectedIndex: index, onTap: _onTap);

    if (useSideNavRail) {
      bottomNavBar = null;
      sideNavRail = SideNavRail(
        selectedIndex: index,
        onTap: _onTap,
        currentRoute: currentRoute,
      );
    }

    return Scaffold(
      key: ValueKey(userId),
      body: Stack(
        children: [
          Row(
            children: [
              sideNavRail,
              Expanded(child: navigationShell),
            ],
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 16,
            right: 16,
            child: const NotificationToastStack(),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }

  void _onTap(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );
}
