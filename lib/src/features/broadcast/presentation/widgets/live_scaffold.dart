import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/application.dart';

class LiveScaffold extends HookWidget {
  const LiveScaffold({
    required this.tabs,
    required this.tabViews,
    super.key,
  });

  final List<Widget> tabs;
  final List<Widget> tabViews;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    final controller = useTabController(initialLength: tabs.length);
    return Stack(
      children: [
        MScaffold(
          padding: EdgeInsets.zero,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                constraints: const BoxConstraints(minHeight: 32),
                child: TabBar(controller: controller, tabs: tabs),
              ),
            ),
          ),
          body: MTabBarView(
            controller: controller,
            children: tabViews,
            onPageChanged: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
        BlocBuilder<LiveBloc, LiveState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const SizedBox(),
            loading: () => Container(
              color: Colors.black.withOpacity(0.8),
              alignment: Alignment.center,
              child: const MLoadingIndicator.box(),
            ),
          ),
        ),
      ],
    );
  }
}
