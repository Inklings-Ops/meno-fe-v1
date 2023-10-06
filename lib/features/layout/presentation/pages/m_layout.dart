import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/router/m_router.dart';
import 'package:meno_fe_v1/shared/constants/m_bottom_navigation_bar_items.dart';

@RoutePage(name: "MLayoutRoute")
class MLayout extends ConsumerWidget {
  const MLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User user = ref.watch(userProvider);

    return AutoTabsScaffold(
      appBarBuilder: (context, tabsRouter) {
        if (tabsRouter.activeIndex == 0) {
          return MAppBar.home(
            title: user.fullName.get()!,
            actions: const [MIconButton(icon: MIcons.bell, size: 20)],
          );
        }

        if (tabsRouter.activeIndex == 3) {
          return MAppBar.home(title: "Profile");
        }

        return MAppBar.secondary(title: tabsRouter.routeData.title(context));
      },
      bottomNavigationBuilder: (context, tabsRouter) => MBottomNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        items: bottomNavigationBarItems,
        onTap: tabsRouter.setActiveIndex,
      ),
      routes: const [
        HomeRoute(),
        DiscoverRoute(),
        NotesRoute(),
        ProfileRoute(),
      ],
    );
  }
}
