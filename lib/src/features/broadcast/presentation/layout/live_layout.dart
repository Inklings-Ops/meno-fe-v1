import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class LiveLayout extends HookWidget {
  const LiveLayout({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LiveLayout'));

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Keeps the widget alive across tab changes,
    // preventing its state from being disposed.
    useAutomaticKeepAlive();

    // Hooks for state management
    final controller = useTabController(
      initialLength: children.length,
      initialIndex: navigationShell.currentIndex,
    );
    final showChatDot = useState(false); // Equivalent to _showChatDot
    final chatTabIndex = useRef(1); // Using useRef for a constant value

    final participantsBloc = context.read<ParticipantsBloc>();
    final chatsBloc = context.read<ChatListBloc>();
    final timerBloc = context.read<TimerCubit>();

    // Effect to handle TabController index changes
    useEffect(
      () {
        void handleTabControllerIndexChange() {
          // If the controller's index is different from the shell,
          // update the shell
          if (controller.index != navigationShell.currentIndex) {
            navigationShell.goBranch(controller.index);
          }
          // Always process chat notification visibility based on the
          // controller's current index
          _processChatNotificationVisibility(controller.index, showChatDot);
        }

        controller.addListener(handleTabControllerIndexChange);
        return () => controller.removeListener(handleTabControllerIndexChange);
      },
      [controller, navigationShell, showChatDot],
    );

    // Effect to sync TabController when navigationShell's index
    // changes externally
    useEffect(
      () {
        if (controller.index != navigationShell.currentIndex) {
          controller.index = navigationShell.currentIndex;
          // After syncing, ensure chat notification state is correct for the
          // new tab
          _processChatNotificationVisibility(controller.index, showChatDot);
        }
        return null; // No cleanup needed for this effect
      },
      [navigationShell.currentIndex, controller, showChatDot],
    );

    // This handles direct tap events from the TabBar, mimicking
    // _onDirectTabTap
    void onDirectTabTap(int tappedIndex) {
      if (controller.index != tappedIndex) {
        controller.animateTo(tappedIndex);
      } else {
        if (navigationShell.currentIndex != tappedIndex) {
          navigationShell.goBranch(tappedIndex);
        }
        _processChatNotificationVisibility(tappedIndex, showChatDot);
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ChatListBloc, ChatListState>(
          listenWhen: (previous, current) {
            return current.chats.length > previous.chats.length &&
                current.chats.isNotEmpty;
          },
          listener: (context, state) {
            if (controller.index != chatTabIndex.value) {
              if (!showChatDot.value) {
                showChatDot.value = true;
              }
            }
          },
        ),
      ],
      child: BlocConsumer<BroadcastBloc, BroadcastState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (ctx, state) {
          final id = state.broadcast.id;
          switch (state.status) {
            case LiveBroadcastStatus.failure:
              final exception = state.exception;
              if (exception == null) return;
              ctx.showErrorSnackBar(exception.message);
            case LiveBroadcastStatus.ended:
              participantsBloc.add(ParticipantsFetchAllRequested(id));
              chatsBloc.add(const ChatResetRequested());
              timerBloc.stop();
              router.replace<void>(Routes.endedBroadcast);
            case LiveBroadcastStatus.left:
              participantsBloc.add(const ParticipantsResetRequested());
              chatsBloc.add(const ChatResetRequested());
              timerBloc.stop();
              router.go(Routes.home);
              ctx.read<BroadcastBloc>().add(const BroadcastResetRequested());
            case LiveBroadcastStatus.initial:
            case LiveBroadcastStatus.loading:
            case LiveBroadcastStatus.joined:
            case LiveBroadcastStatus.started:
            case LiveBroadcastStatus.reconnecting:
            case LiveBroadcastStatus.offAir:
              return;
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          final isLoading = state.status.isLoading;
          if (isLoading) return const LiveLoadingIndicatorOverlay();
          return Scaffold(
            appBar: BroadcastAppBar(
              key: const Key('LiveSessionLayoutAppBar'),
              controller: controller,
              onTabChanged: onDirectTabTap,
              showChatDot: showChatDot.value,
            ),
            body: MTabBarView(
              controller: controller,
              children: children,
              onPageChanged: (_) => FocusScope.of(context).unfocus(),
            ),
          );
        },
      ),
    );
  }

  // Centralized logic to show/hide the chat dot
  void _processChatNotificationVisibility(
    int targetIndex,
    ValueNotifier<bool> showChatDot,
  ) {
    const chatTabIndex = 1; // Keeping it as a constant here for clarity
    if (targetIndex == chatTabIndex) {
      if (showChatDot.value) {
        showChatDot.value = false; // Update state using .value
      }
    }
  }
}
