import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastPage extends HookWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastBloc>();
    return BlocListener<BroadcastBloc, BroadcastState>(
      bloc: bloc,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        state.whenOrNull(
          failure: (exception) => context.showBroadcastError(exception),
          deleteSuccess: () => router.go(Routes.home),
          startFailed: (e) => context.showErrorSnackBar(e.toString()),
          startSuccess: (broadcast, muted) {
            context.read<TimerCubit>().start();
            context.read<LiveParticipantsBloc>().initialize(broadcast);
            context.read<ChatBloc>().initialize(broadcast);
          },
          endSuccess: () {
            context.read<TimerCubit>().stop();
            context.read<LiveKitService>().dispose();
            context.showModal<void>(
              const BroadcastEndedModal(),
              enableDrag: false,
              useRootNavigator: true,
              isDismissible: false,
              isScrollControlled: true,
            );
          },
        );
      },
      child: const LiveStreamScaffold(
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
