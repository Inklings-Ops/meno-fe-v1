import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';



class BroadcastPage extends StatelessWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const LiveScaffold(
        tabs: [
          Tab(text: 'Broadcast'),
          Tab(text: 'Chats'),
          Tab(text: 'Live Bible'),
          Tab(text: 'Notes'),
        ],
        tabViews: [
          BroadcastTab(),
          BroadcastChatTab(),
          LiveBibleTab(),
          NotesTab(),
        ],
      ),
    );
  }
}
