import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastPage extends HookWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    final controller = useTabController(initialLength: 4);

    return BlocListener<BroadcastBloc, BroadcastState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (ctx, state) {
        final broadcast = state.broadcast;
        state.status.whenOrNull(
          failed: ctx.showBroadcastError,
          started: (_) {
            ctx.read<TimerCubit>().start();
            ctx.read<LiveParticipantsBloc>().initialize(broadcast);
            ctx.read<ChatBloc>().initialize(broadcast);
            ctx.read<MenoBloc>().update(const MLive());
          },
          ended: (_) {
            ctx.read<TimerCubit>().stop();
            ctx.read<LiveKitService>().disconnect();
            ctx.read<LiveParticipantsBloc>().fetchTotal();
            ctx.read<MenoBloc>().update(const MOffAir());
            ctx.showModal<void>(
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: ctx.read<BroadcastBloc>()),
                  BlocProvider.value(value: ctx.read<ChatBloc>()),
                  BlocProvider.value(value: ctx.read<LiveParticipantsBloc>()),
                ],
                child: const BroadcastEndedModal(),
              ),
              enableDrag: false,
              useRootNavigator: true,
              isDismissible: false,
              isScrollControlled: true,
            );
          },
        );
      },
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
          children: const [
            BroadcastTab(),
            BroadcastChatTab(),
            LiveBibleTab(),
            NotesTab(),
          ],
          onPageChanged: (_) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }
}
