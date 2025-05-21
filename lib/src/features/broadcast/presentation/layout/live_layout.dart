import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class LiveLayout extends StatefulWidget {
  const LiveLayout({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LiveLayout'));

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<LiveLayout> createState() => _LiveLayoutState();
}

class _LiveLayoutState extends State<LiveLayout>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController controller;
  bool _showChatDot = false;
  final int _chatTabIndex = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        MultiBlocListener(
          listeners: [
            BlocListener<ChatListBloc, ChatListState>(
              listenWhen: (previous, current) {
                return current.chats.length > previous.chats.length &&
                    current.chats.isNotEmpty;
              },
              listener: (context, state) {
                if (controller.index != _chatTabIndex) {
                  if (!_showChatDot) {
                    if (mounted) setState(() => _showChatDot = true);
                  }
                }
              },
            ),
            BlocListener<BroadcastBloc, BroadcastState>(
              listener: (context, state) {
                if (state.status.isLeft) {
                  router.go(Routes.home);
                }
              },
            ),
          ],
          child: Scaffold(
            appBar: BroadcastAppBar(
              showChatDot: _showChatDot,
              controller: controller,
              onTabTap: widget.navigationShell.goBranch,
            ),
            body: MTabBarView(
              controller: controller,
              children: widget.children,
              onPageChanged: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
        ),
        const LiveLoadingIndicatorOverlay(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: widget.children.length,
      vsync: this,
      initialIndex: widget.navigationShell.currentIndex,
    )..addListener(_handleTabControllerIndexChange);
  }

  @override
  void dispose() {
    controller.removeListener(_handleTabControllerIndexChange);
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LiveLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync TabController if navigationShell's index changed externally
    if (controller.index != widget.navigationShell.currentIndex) {
      controller.index = widget.navigationShell.currentIndex;
      // After syncing ensure chat notification state is correct for the new tab
      _processChatNotificationVisibility(controller.index);
    }
  }

  // Handles index changes from TabController (e.g., swipes, programmatic
  // changes on controller)
  void _handleTabControllerIndexChange() {
    // If the controller's index is different from the shell, update the shell
    if (controller.index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(controller.index);
    }

    // Always process chat notification visibility based on the controller's
    // current index
    _processChatNotificationVisibility(controller.index);
  }

  // Handles direct tap events from the TabBar
  void _onDirectTabTap(int tappedIndex) {
    // If the tapped index is different from the current controller index,
    // tell the controller to animate to the new index.
    // This will subsequently trigger _handleTabControllerIndexChange.
    if (controller.index != tappedIndex) {
      controller.animateTo(tappedIndex);
    } else {
      // If tapping the already active tab the controller listener may not fire
      // Explicitly update navigation shell (if needed) & process notification.
      if (widget.navigationShell.currentIndex != tappedIndex) {
        widget.navigationShell.goBranch(tappedIndex);
      }
      _processChatNotificationVisibility(tappedIndex);
    }
  }

  // Centralized logic to show/hide the chat dot
  void _processChatNotificationVisibility(int targetIndex) {
    if (targetIndex == _chatTabIndex) {
      if (_showChatDot) {
        if (mounted) setState(() => _showChatDot = false);
      }
    }
  }
}
