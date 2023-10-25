import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../router/router.dart';
import '../../../shared/constants/m_bottom_navigation_bar_items.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: MBottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _activeIndex(context),
        onTap: (index) => setActiveIndex(index, context),
        customItem: MBottomBarNavigationItem(
          selected: false,
          onTap: () => context.push(Routes.createBroadcast),
          customItem: const Microphone(),
        ),
      ),
    );
  }

  static int _activeIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(Routes.home)) {
      return 0;
    }
    if (location.startsWith(Routes.discover)) {
      return 1;
    }
    if (location.startsWith(Routes.notes)) {
      return 2;
    }
    if (location.startsWith(Routes.profile)) {
      return 3;
    }
    return 0;
  }

  void setActiveIndex(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.discover);
        break;
      case 2:
        context.go(Routes.notes);
        break;
      case 3:
        context.go(Routes.profile);
        break;
      default:
        context.go(Routes.home);
        break;
    }
  }
}

// class AppLayout extends HookWidget {
//   const AppLayout({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = useState(0);

//     return Scaffold(
//       body: _page(currentIndex.value),
//       bottomNavigationBar: MBottomNavigationBar(
//         items: bottomNavigationBarItems,
//         currentIndex: currentIndex.value,
//         onTap: (index) => currentIndex.value = index,
//         customItem: MBottomBarNavigationItem(
//           selected: false,
//           onTap: () => context.push(Routes.createBroadcast),
//           customItem: const Microphone(),
//         ),
//       ),
//     );
//   }

//   Widget _page(int index) {
//     switch (index) {
//       case 0:
//         return const HomePage();
//       case 1:
//         return const DiscoverPage();
//       case 2:
//         return const NotesPage();
//       case 3:
//         return const ProfilePage();
//       default:
//         return const HomePage();
//     }
//   }
// }
