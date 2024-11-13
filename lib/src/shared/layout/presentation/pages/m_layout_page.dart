import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';
import 'package:meno_fe_v1/src/services/notification_service.dart';
import 'package:meno_fe_v1/src/services/permissions_service.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

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

    useEffect(
      () {
        final token = context.select<SessionCubit, Token?>(
          (bloc) => bloc.state.whenOrNull(
            authenticated: (user, token) => token,
          ),
        );
        context.read<SocketBloc>().add(SocketConnect(token!));
        di<PermissionsService>().requestNotificationsPermissions();
        di<IBibleFacade>().init();
        firebaseMessaging.getInitialMessage().then(onInitialMessage);
        FirebaseMessaging.onMessage.listen(showFlutterNotification);
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          router.push(Routes.notifications);
        });
        handleFCMToken();
        return null;
      },
      [firebaseMessaging, initMessage],
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

    final isStreaming = context.select<LiveBloc, bool>((bloc) {
      return bloc.state.maybeWhen(orElse: () => false, streaming: () => true);
    });

    return MultiBlocListener(
      listeners: [
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              broadcastEnded: () {
                Logger().e('FROM LAYOUTTTTTTTT');
                // context.read<TimerCubit>().stop();
                // context.read<LiveKitBloc>().add(const LiveKitDisconnect());
                // context.read<ChatBloc>().add(const ChatReset());
                // context.read<LiveBloc>().add(const LiveReset());
                // if (router.state?.path == Routes.broadcast) {
                //   router.go(Routes.endedBroadcast);
                // } else {
                //   router.push(Routes.endedBroadcast);
                // }
              },
              endedBroadcast: (data) {
                if (!isStreaming) return;
                context.read<LiveBloc>().add(const LiveReset());
                context.read<LiveKitBloc>().add(const LiveKitDisconnect());
                context.read<ParticipantsBloc>().add(const ParticipantsReset());
                context.read<ChatBloc>().add(const ChatReset());
                context.read<StreamBloc>().add(const StreamReset());
                context.read<TimerCubit>().dispose();
                router.go(Routes.home);
                context.showErrorSnackBar(data.reason.message);
              },
              broadcastLeft: () {
                context.read<LiveBloc>().add(const LiveReset());
                context.read<LiveKitBloc>().add(const LiveKitDisconnect());
                context.read<ParticipantsBloc>().add(const ParticipantsReset());
                context.read<ChatBloc>().add(const ChatReset());
                context.read<StreamBloc>().add(const StreamReset());
                context.read<TimerCubit>().dispose();
                router.go(Routes.home);
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
