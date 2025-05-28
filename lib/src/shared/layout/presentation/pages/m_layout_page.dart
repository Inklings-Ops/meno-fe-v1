import 'package:meno_fe_v1/app/meno_bloc_listeners.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart' hide StreamState;

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
    final initMessage = useState<String?>(null);

    void onInitialMessage(RemoteMessage? value) {
      initMessage.value = value?.data.toString();
    }

    final permissions = di<PermissionsService>();

    useEffect(
      () {
        // Initialize the Bible and start parsing the KJV to store in the DB
        di<IBibleFacade>().initialize();
        firebaseMessaging.getInitialMessage().then(onInitialMessage);
        FirebaseMessaging.onMessage.listen(showFlutterNotification);
        FirebaseMessaging.onMessageOpenedApp.listen(openNotifications);
        handleFCMToken();

        return null;
      },
      [firebaseMessaging, initMessage, permissions],
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

    return MenoBlocListeners(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          switch (state) {
            case AccountInitial():
            case AccountLoadInProgress():
              return const LoadingPage();
            case AccountLoadFailure():
            case AccountLoadSingleAccountSuccess():
            case AccountLoadSuccess():
              return Scaffold(
                body: Row(children: [sideNavRail, Expanded(child: shell)]),
                bottomNavigationBar: bottomNavBar,
              );
          }
        },
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
