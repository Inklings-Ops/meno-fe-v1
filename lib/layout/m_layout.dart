import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/router/m_router.dart';

const List<BottomNavigationBarItem> _items = [
  BottomNavigationBarItem(icon: Icon(MIcons.home_04), label: "Home"),
  BottomNavigationBarItem(icon: Icon(MIcons.compass), label: "Discover"),
  BottomNavigationBarItem(icon: Icon(MIcons.file), label: "Notes"),
  BottomNavigationBarItem(icon: Icon(MIcons.user_circle), label: "Profile"),
];

@RoutePage(name: "MLayoutRoute")
class MLayout extends StatefulWidget {
  const MLayout({super.key});

  @override
  State<MLayout> createState() => _MLayoutState();
}

class _MLayoutState extends State<MLayout> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      appBarBuilder: (context, tabsRouter) {
        if (tabsRouter.activeIndex == 0) {
          return MAppBar.home(
            title: "John Doe",
            actions: const [
              MIconButton(icon: MIcons.bell, size: 20),
            ],
          );
        }

        if (tabsRouter.activeIndex == 4) {
          return MAppBar.home(title: "Profile");
        }

        return MAppBar.secondary(title: tabsRouter.routeData.title(context));
      },
      bottomNavigationBuilder: (context, tabsRouter) => MBottomNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        items: _items,
        onTap: tabsRouter.setActiveIndex,
      ),
      routes: const [
        HomeRoute(),
        DiscoverRoute(),
        NotesRoute(),
        ProfileRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
