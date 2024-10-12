import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveStreamScaffold extends HookWidget {
  const LiveStreamScaffold({
    required this.shell,
    required this.children,
    super.key,
  });
  final StatefulNavigationShell shell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: children.length);
    return MultiBlocListener(
      listeners: [
        BlocListener<BroadcastBloc, BroadcastState>(
          bloc: context.watch<BroadcastBloc>(),
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            final broadcast = state.broadcast;
            switch (state.status) {
              case LiveStatus.failure:
                context.read<MenoBloc>().add(const MenoStateChanged(MOffAir()));
                context.showBroadcastError(state.failure);
                return;
              case LiveStatus.deleted:
                context.read<MenoBloc>().add(const MenoStateChanged(MOffAir()));
                context.go(Routes.home);
                return;
              case LiveStatus.started:
                context.read<MenoBloc>().add(const MenoStateChanged(MLive()));
                context.read<TimerCubit>().start();
                context.read<LiveParticipantsBloc>().initialize(broadcast);
                context.read<ChatBloc>().initialize(broadcast);
                return;
              case LiveStatus.ended:
                context.read<TimerCubit>().stop();
                context.read<LiveKitService>().disconnect();
                context.showModal<void>(
                  BlocProvider.value(
                    value: context.read<BroadcastBloc>(),
                    child: const BroadcastEndedModal(),
                  ),
                  enableDrag: false,
                  useRootNavigator: true,
                  isDismissible: false,
                  isScrollControlled: true,
                );
                return;
              case LiveStatus.initial:
              case LiveStatus.loading:
              case LiveStatus.left:
                context.read<MenoBloc>().add(const MenoStateChanged(MOffAir()));
              case LiveStatus.joined:
                return;
            }
          },
        ),
      ],
      child: MScaffold(
        padding: EdgeInsets.zero,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              constraints: const BoxConstraints(minHeight: 32),
              child: TabBar(
                controller: controller,
                onTap: shell.goBranch,
                tabs: const [
                  Tab(text: 'Broadcast'),
                  Tab(text: 'Chats'),
                  Tab(text: 'Live Bible'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),
          ),
        ),
        body: MTabBarView(
          controller: controller,
          children: children,
          onPageChanged: (value) {
            FocusScope.of(context).unfocus();
            shell.goBranch(value);
          },
        ),
      ),
    );
  }
}
