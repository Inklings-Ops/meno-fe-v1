// 
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meno_design_system/meno_design_system.dart';

// import '../../../features/auth/application/application.dart';
// import '../../../features/auth/domain/domain.dart';
// import '../../../router/router.dart';
// import '../../../shared/constants/m_bottom_navigation_bar_items.dart';

// @RoutePage(name: "MLayoutRoute")
// class MLayout extends HookConsumerWidget {

//   const MLayout({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final loading = useState(false);

//     useEffect(() {
//       loading.value = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await ref.read(authProvider.notifier).checkAuthenticated();
//       });
//       loading.value = false;
//       return null;
//     }, const []);

//     if (loading.value) {
//       return const Scaffold(body: MLoadingIndicator.box());
//     } else {
//       User user = ref.read(userProvider);
//       return AutoTabsScaffold(
//         appBarBuilder: (context, tabsRouter) {
//           if (tabsRouter.activeIndex == 0) {
//             return MAppBar.home(
//               title: user.fullName.get()!,
//               actions: const [MIconButton(icon: MIcons.bell, size: 20)],
//             );
//           }

//           if (tabsRouter.activeIndex == 3) {
//             return MAppBar.home(title: "Profile");
//           }

//           return MAppBar.secondary(title: tabsRouter.routeData.title(context));
//         },
//         bottomNavigationBuilder: (context, tabsRouter) => MBottomNavigationBar(
//           currentIndex: tabsRouter.activeIndex,
//           items: bottomNavigationBarItems,
//           onTap: tabsRouter.setActiveIndex,
//           customItem: MBottomBarNavigationItem(
//             selected: false,
//             onTap: () => context.navigateTo(const CreateBroadcastRoute()),
//             customItem: const Microphone(),
//           ),
//         ),
//         routes: const [
//           HomeRoute(),
//           DiscoverRoute(),
//           NotesRoute(),
//           ProfileRoute(),
//         ],
//       );
//     }
//   }
// }
