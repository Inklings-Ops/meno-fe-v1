import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/live_session_manager.dart';
import 'package:meno/shared/presentation/live_layout/live_app_bar.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveLayoutWidget extends WatchingStatefulWidget {
  const LiveLayoutWidget({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LiveLayoutWidget'));

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<LiveLayoutWidget> createState() => LiveLayoutWidgetState();
}

class LiveLayoutWidgetState extends State<LiveLayoutWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final TabController controller;

  final showChatDot = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: widget.children.length,
      vsync: this,
      initialIndex: widget.navigationShell.currentIndex,
    );

    controller.addListener(handleTabControllerIndexChange);

    if (controller.index != widget.navigationShell.currentIndex) {
      controller.index = widget.navigationShell.currentIndex;
    }
  }

  @override
  void dispose() {
    controller.removeListener(handleTabControllerIndexChange);
    controller.dispose();
    showChatDot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    registerHandler(
      select: (LiveSessionManager m) => m.endSession,
      handler: (context, newValue, cancel) => context.go(R.endedBroadcast),
    );

    return Scaffold(
      appBar: LiveAppBar(
        key: const Key('LiveSessionLayoutAppBar'),
        controller: controller,
        onTabChanged: onDirectTabTap,
        showChatDot: showChatDot.value,
      ),
      body: MTabBarView(
        controller: controller,
        children: widget.children,
        onPageChanged: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void handleTabControllerIndexChange() {
    // If the controller's index is different from the shell,
    // update the shell
    if (controller.index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(controller.index);
    }
  }

  void onDirectTabTap(int tappedIndex) {
    if (controller.index != tappedIndex) {
      controller.animateTo(tappedIndex);
    } else {
      if (widget.navigationShell.currentIndex != tappedIndex) {
        widget.navigationShell.goBranch(tappedIndex);
      }
    }
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
