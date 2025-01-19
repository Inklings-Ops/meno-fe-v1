import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LiveLayoutListeners(
      child: Stack(
        children: [
          Scaffold(
            appBar: BroadcastAppBar(
              controller: controller,
              onTabTap: widget.navigationShell.goBranch,
            ),
            body: MTabBarView(
              controller: controller,
              children: widget.children,
              onPageChanged: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
          const LiveLoadingIndicatorOverlay(),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LiveLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.index = widget.navigationShell.currentIndex;
  }

  @override
  void dispose() {
    controller.removeListener(_onTabSwitched);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: widget.children.length,
      vsync: this,
      initialIndex: widget.navigationShell.currentIndex,
    )..addListener(_onTabSwitched);
  }

  void _onTabSwitched() {
    if (controller.index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(controller.index);
    }
  }
}
