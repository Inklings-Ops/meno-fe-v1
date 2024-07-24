import 'package:meno_fe_v1/meno.dart';

class LiveStreamScaffold extends HookWidget {
  final List<Widget> tabs;
  final List<Widget> tabViews;

  const LiveStreamScaffold({
    super.key,
    required this.tabs,
    required this.tabViews,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: tabs.length);
    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.toScale),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0).radius,
            constraints: const BoxConstraints(minHeight: 32).radius,
            child: TabBar(controller: controller, tabs: tabs),
          ),
        ),
      ),
      body: MTabBarView(
        controller: controller,
        children: tabViews,
        onPageChanged: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
