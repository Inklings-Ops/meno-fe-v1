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
  State<LiveLayoutWidget> createState() => _LiveLayoutWidgetState();
}

class _LiveLayoutWidgetState extends _LiveLayoutBase {
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
      // After syncing, ensure chat notification state is correct for the
      // new tab
      _processChatNotificationVisibility(controller.index, showChatDot);
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

    final isDIReady = isReady<LiveSessionManager>();
    if (!isDIReady) return const LiveLoadingIndicatorOverlay();

    final liveStatus = watchValue((LiveSessionManager m) => m.liveStatus);

    final isInitializing =
        liveStatus == LiveStatus.initializing ||
        liveStatus == LiveStatus.connecting;

    if (isInitializing) return const LiveLoadingIndicatorOverlay();

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

  @override
  bool get wantKeepAlive => true;

  void handleTabControllerIndexChange() {
    // If the controller's index is different from the shell,
    // update the shell
    if (controller.index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(controller.index);
    }
    // Always process chat notification visibility based on the
    // controller's current index
    _processChatNotificationVisibility(controller.index, showChatDot);
  }

  void onDirectTabTap(int tappedIndex) {
    if (controller.index != tappedIndex) {
      controller.animateTo(tappedIndex);
    } else {
      if (widget.navigationShell.currentIndex != tappedIndex) {
        widget.navigationShell.goBranch(tappedIndex);
      }
      _processChatNotificationVisibility(tappedIndex, showChatDot);
    }
  }
}

abstract class _LiveLayoutBase extends State<LiveLayoutWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // You can even put shared logic here if you wanted!
}

class LiveLoadingIndicatorOverlay extends StatelessWidget {
  const LiveLoadingIndicatorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.8),
      child: const SizedBox.expand(
        child: Center(child: MLoadingIndicator(100, 100)),
      ),
    );
  }
}
