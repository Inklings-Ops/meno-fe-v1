import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastPage extends StatelessWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BroadcastBloc, BroadcastState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        state.status.whenOrNull(
          failed: context.showBroadcastError,
          broadcastEnded: () => _onEndedBroadcast(context),
          started: (_, reconnected) => _onStartedBroadcast(
            context: context,
            broadcast: state.broadcast,
            reconnected: reconnected,
          ),
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

  void _onStartedBroadcast({
    required BuildContext context,
    required Broadcast broadcast,
    required bool reconnected,
  }) {
    context.read<ChatBloc>().add(ChatInitialized(broadcast));
    context.read<ParticipantsBloc>().add(ParticipantsInitialized(broadcast));
    context.read<MenoBloc>().update(const MLive());
    if (reconnected) {
      context.read<TimerCubit>().setAndStart(broadcast.startTime);
    } else {
      context.read<TimerCubit>().start();
    }
  }

  void _onEndedBroadcast(BuildContext context) {
    context.read<TimerCubit>().stop();
    di<LiveKitService>().disconnect();
    context.read<ParticipantsBloc>().add(const AllParticipantsFetchPressed());
    context.read<MenoBloc>().update(const MOffAir());
    context.showModal<void>(
      const BroadcastEndedModal(),
      enableDrag: false,
      useRootNavigator: true,
      isDismissible: false,
      isScrollControlled: true,
    );
  }
}
