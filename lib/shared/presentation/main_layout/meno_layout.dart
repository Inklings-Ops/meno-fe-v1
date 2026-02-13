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
    // final firebaseMessaging = FirebaseMessaging.instance;
    // final initMessage = useState<String?>(null);

    // void onInitialMessage(RemoteMessage? value) {
    //   initMessage.value = value?.data.toString();
    // }
    //
    // final permissions = di<PermissionsService>();
    //
    // useEffect(() {
    //   // Initialize the Bible and start parsing the KJV to store in the DB
    //   di<IBibleFacade>().initialize();
    //   firebaseMessaging.getInitialMessage().then(onInitialMessage);
    //   FirebaseMessaging.onMessage.listen(showFlutterNotification);
    //   FirebaseMessaging.onMessageOpenedApp.listen(openNotifications);
    //   handleFCMToken();
    //
    //   return null;
    // }, [firebaseMessaging, initMessage, permissions]);

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

    final userId = watchValue((AuthManager m) => m.userId);

    return Scaffold(
      key: ValueKey('menoLayout_$userId'),
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
