import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/notification_service.dart';
import 'package:meno_fe_v1/src/services/permissions_service.dart';

class MLayoutPage extends HookWidget {
  const MLayoutPage({
    required this.shell,
    required this.currentRoute,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('MLayout'));
  final StatefulNavigationShell shell;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final firebaseMessaging = FirebaseMessaging.instance;
    final initialMessage = useState<String?>(null);

    useEffect(
      () {
        di<PermissionsService>().requestNotificationsPermissions();
        di<IBibleFacade>().init();
        firebaseMessaging
            .getInitialMessage()
            .then((value) => initialMessage.value = value?.data.toString());
        FirebaseMessaging.onMessage.listen(showFlutterNotification);
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          router.push(Routes.notifications);
        });
        handleFCMToken();
        return null;
      },
      [firebaseMessaging, initialMessage],
    );

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

    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user, token) {
            context.read<LiveBroadcastsBloc>().init();
            context.read<RecentlyLiveCubit>().fetch();
          },
        );
      },
      child: Scaffold(
        body: Row(children: [sideNavRail, Expanded(child: shell)]),
        bottomNavigationBar: bottomNavBar,
      ),
    );
  }

  void onTap(int index) {
    return shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }
}
