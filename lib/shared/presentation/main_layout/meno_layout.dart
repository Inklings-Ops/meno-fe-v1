import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno/shared/shared.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MenoLayout extends WatchingWidget {
  const MenoLayout({required this.shell, required this.currentRoute, Key? key})
    : super(key: key ?? const ValueKey<String>('MLayout'));

  final StatefulNavigationShell shell;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    // final snapshot = watchFuture<GetIt, void>(
    //   (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
    //   target: di,
    //   initialValue: null,
    // );
    //
    // if (snapshot.hasError) return MenoErrorWidget(error: snapshot.error);
    //
    // if (snapshot.isLoading) return const LoadingPage();

    final userId = watchValue((AuthManager m) => m.userId).toNullable();

    final index = shell.currentIndex;
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
      key: ValueKey(userId?.getOrNull()),
      body: Row(
        children: [
          sideNavRail,
          Expanded(child: shell),
        ],
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }

  void onTap(int index) {
    return shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }
}
