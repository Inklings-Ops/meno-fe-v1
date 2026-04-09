import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/broadcast/manager/live_session_manager.dart';
import 'package:meno/features/broadcast/model/live_session_state.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveSessionShell extends WatchingStatefulWidget {
  const LiveSessionShell._({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => LiveSessionShell._(
    key: const ValueKey<String>('LiveSessionShell'),
    navigationShell: navigationShell,
    children: children,
  );

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<LiveSessionShell> createState() => LiveSessionShellState();
}

class LiveSessionShellState extends State<LiveSessionShell>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  final showChatDot = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final state = watchValue((LiveSessionManager m) => m.state);

    registerHandler(
      select: (LiveSessionManager m) => m.endSession,
      handler: (context, result, cancel) {
        if (state is LiveSessionStreaming) return;
        context.go(R.endedBroadcast);
      },
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => context.replace(R.home),
      child: Scaffold(
        appBar: _AppBar(
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
      ),
    );
  }

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

/// Custom AppBar for the live session, including tabs and a chat
/// notification dot.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an _AppBar.
  const _AppBar({
    required this.controller,
    required this.showChatDot,
    this.onTabChanged,
    super.key,
  });

  final TabController controller;
  final void Function(int)? onTabChanged;
  final bool showChatDot;

  @override
  Widget build(BuildContext context) {
    Widget icon = const SizedBox.shrink();
    if (showChatDot) {
      icon = Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: Colors.red, shape: .circle),
        ),
      );
    }
    return SafeArea(
      child: Padding(
        padding: const .symmetric(horizontal: Insets.lg),
        child: MTabBar.normal(
          controller: controller,
          onTap: onTabChanged,
          tabs: [
            const MenoTab(text: 'Broadcast'),
            MenoTab(text: 'Chat', icon: icon),
            const MenoTab(text: 'Live Bible'),
            const MenoTab(text: 'Live Notes'),
          ],
          padding: .zero,
          isScrollable: false,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const .fromHeight(kToolbarHeight);
}
