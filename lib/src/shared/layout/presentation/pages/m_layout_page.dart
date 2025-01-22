import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

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

        // Retrieve the auth token and use it to connect to the Socket
        final token = context.select<SessionCubit, Token?>(
          (bloc) => bloc.state.whenOrNull(authenticated: (_, token) => token),
        );
        context.read<SocketBloc>().add(SocketConnect(token!));

        // Request/Check for notifications permissions and initialize FCM
        permissions.requestNotificationsPermissions(context).then((perm) async {
          if (perm) {
            await firebaseMessaging.getInitialMessage().then(onInitialMessage);
            FirebaseMessaging.onMessage.listen(showFlutterNotification);
            FirebaseMessaging.onMessageOpenedApp.listen(openNotifications);
            await handleFCMToken();
          }
        });
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

    final broadcastBloc = context.read<BroadcastBloc>();
    final livekit = context.read<LiveKitBloc>();
    final live = context.read<LiveBloc>();
    final background = di<BackgroundService>();
    // final streamBloc = context.read<StreamBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              hostReconnected: (value) {
                Logger().f('Host reconnected => //');
                live.add(const GoLoading());
                broadcastBloc.add(const BroadcastReconnectRequested());
              },
            );
          },
        ),
        BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            state.status.whenOrNull(
              failure: (error) {
                live.add(const GoFailure());
                context.showBroadcastError(error);
              },
              broadcastStarted: () async {
                final broadcast = broadcastBloc.state.broadcast;
                await background.startBroadcastBackgroundProcess(broadcast);
                livekit.add(
                  LiveKitBroadcast(
                    token: broadcast.broadcastToken,
                    isReconnect: true,
                  ),
                );
                await router.push<void>(Routes.broadcastTab);
              },
            );
          },
        ),
      ],
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
