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
          started: (_) => _onStartedBroadcast(context, state.broadcast),
          ended: (_) => _onEndedBroadcast(context),
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

  void _onStartedBroadcast(BuildContext context, Broadcast broadcast) {
    context.read<ChatBloc>().add(ChatInitialized(broadcast));
    context.read<ParticipantsBloc>().add(ParticipantsInitialized(broadcast));
    context.read<TimerCubit>().start();
    context.read<MenoBloc>().update(const MLive());
  }

  void _onEndedBroadcast(BuildContext context) {
    context.read<TimerCubit>().stop();
    context.read<LiveKitService>().disconnect();
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
