import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RootLayout extends WatchingWidget {
  const RootLayout._({
    required this.navigationShell,
    required this.currentRoute,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => RootLayout._(
    key: const ValueKey<String>('LiveSessionShell'),
    navigationShell: navigationShell,
    currentRoute: state.path,
  );

  final StatefulNavigationShell navigationShell;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final snapshot = watchFuture<GetIt, void>(
      (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
      target: di,
      initialValue: null,
    );

    if (snapshot.hasError) return MenoErrorWidget(error: snapshot.error);

    if (snapshot.isLoading) return const LoadingPage();

    final userId = watchValue((AuthManager m) => m.activeUserId);

    final index = navigationShell.currentIndex;
    final useSideNavRail = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    Widget sideNavRail = const SizedBox();
    Widget? bottomNavBar = BottomNavBar(selectedIndex: index, onTap: onTap);

    if (useSideNavRail) {
      bottomNavBar = null;
      sideNavRail = SideNavRail(
        selectedIndex: index,
        onTap: onTap,
        currentRoute: currentRoute,
      );
    }

    return Scaffold(
      key: ValueKey(userId),
      body: Row(
        children: [
          sideNavRail,
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }

  void onTap(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );
}
