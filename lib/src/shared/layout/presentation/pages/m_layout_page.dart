import 'package:logger/logger.dart';
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
      Logger().w(initMessage.value);
    }

    final permissions = di<PermissionsService>();

    useEffect(
      () {
        // Initialize the Bible and start parsing the KJV to store in the DB
        di<IBibleFacade>().initialize();

        // Retrieve the auth token and use it to connect to the Socket
        final token = context.select<SessionBloc, Token?>(
          (bloc) => bloc.state.whenOrNull(authenticated: (_, token) => token),
        );
        context.read<SocketBloc>().add(SocketConnect(token!));

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

    final livekit = context.read<LiveKitBloc>();
    final live = context.read<LiveBloc>();
    final background = di<BackgroundService>();
    final broadcastBloc = context.read<BroadcastBloc>();
    final streamBloc = context.read<StreamBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          listener: (context, state) {
            state.whenOrNull(
              authenticated: (user, token) {
                context.read<RecentlyLiveCubit>().fetch();
                context
                    .read<LiveBroadcastsBloc>()
                    .add(const GetLiveBroadcasts());
                context.read<AccountBloc>().add(const AccountInitialized());
                context.read<NotesBloc>().add(const GetNotesRequested());
                context.read<FoldersBloc>().add(const GetFoldersRequested());
                context.read<MyProfileCubit>().fetch();
              },
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              connected: () => Logger().w('CONNECTED TO SOCKET'),
              hostReconnected: (value) {
                live.add(const GoLoading());
                context.showSnackBar('The host has been reconnected.');
                broadcastBloc.add(const BroadcastReconnectRequested());
              },
              hostDisconnected: (value) {
                context.showSnackBar('The host has been disconnected.');
              },
              newBroadcastListener: (data) {
                final isHost = [Role.HOST, Role.host].contains(data.role);
                final isStreaming = live.state is Streaming;
                if (!isStreaming && !isHost) {
                  live.add(const GoLoading());
                  streamBloc.add(const StreamReconnectRequested());
                } else {
                  final userFullName = data.fullName;
                  context.showSnackBar('$userFullName joined the broadcast.');
                }
              },
              endedBroadcast: (data) {
                context.showSnackBar(data.reason.message);
              },
              broadcastListenerLeft: (participant) {
                final userFullName = participant.fullName;
                context.showSnackBar('$userFullName left the broadcast.');
              },
            );
          },
        ),
        BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            if (state.isReconnect) {
              state.status.whenOrNull(
                failure: (error) {
                  live.add(const GoFailure());
                  context.showBroadcastError(error);
                },
                broadcastStarted: () async {
                  final broadcast = broadcastBloc.state.broadcast;
                  await background.startBroadcastBackgroundProcess(broadcast);
                  final token = broadcast.broadcastToken;
                  livekit
                      .add(LiveKitBroadcast(token: token, isReconnect: true));
                  await router.push<void>(Routes.broadcastTab);
                },
              );
            }
          },
        ),
        BlocListener<StreamBloc, StreamState>(
          listener: (context, state) {
            if (state.isReconnect) {
              state.status.whenOrNull(
                failure: (error) {
                  live.add(const GoFailure());
                  context.showBroadcastError(error);
                },
                streamJoined: (token) async {
                  live.add(const GoLoading());
                  final broadcast = streamBloc.state.broadcast;
                  await background.startBroadcastBackgroundProcess(broadcast);
                  livekit.add(LiveKitStream(token: token, isReconnect: true));
                  await router.push<void>(Routes.broadcastTab, extra: true);
                },
              );
            }
          },
        ),
        BlocListener<AccountBloc, AccountState>(
          listenWhen: (p, c) => p is AccountLoaded != c is AccountLoaded,
          listener: (context, state) {
            state.whenOrNull(
              loaded: (credential, _) => router.refresh(),
              failure: (failure) => context
                ..pop()
                ..showLoginError(failure),
            );
          },
        ),
      ],
      child: BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (p, c) => p is AccountLoading != c is AccountLoading,
        builder: (context, state) => state.maybeWhen(
          loading: () => const Scaffold(
            body: ColoredBox(
              color: Colors.black,
              child: SizedBox.expand(
                child: Center(child: MLoadingIndicator(130, 130)),
              ),
            ),
          ),
          orElse: () => Scaffold(
            body: Row(children: [sideNavRail, Expanded(child: shell)]),
            bottomNavigationBar: bottomNavBar,
          ),
        ),
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
