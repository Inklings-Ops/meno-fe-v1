import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class StreamPage extends HookWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        final broadcast = context.read<StreamBloc>().state.broadcast;
        context.read<TimerCubit>().setAndStart(broadcast.startTime);
        context.read<ChatBloc>().add(ChatInitialized(broadcast));

        context.read<LiveParticipantsBloc>().initialize(broadcast);
        context.read<MenoBloc>().update(const MStreaming());
        return null;
      },
      const [],
    );

    return BlocListener<StreamBloc, StreamState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        state.status.whenOrNull(
          failed: context.showBroadcastError,
          ended: (data) {
            context.read<MenoBloc>().update(const MOffAir());
            router.go(Routes.home);
            cleanUp(context);
          },
          left: () {
            context.read<MenoBloc>().update(const MOffAir());
            router.go(Routes.home);
            cleanUp(context);
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
          StreamTab(),
          StreamChatTab(),
          LiveBibleTab(),
          NotesTab(),
        ],
      ),
    );
  }

  void _handleStreamEnd(BuildContext context) {
    context.read<MenoBloc>().update(const MOffAir());
    router.go(Routes.home);
    context.read<LiveKitService>().dispose();
    context.read<ChatBloc>().add(const ChatReset());

    context.read<StreamBloc>().dispose();
    context.read<TimerCubit>().dispose();
    context.read<LiveParticipantsBloc>().close();
  }

  void cleanUp(BuildContext context) {
    context.read<StreamBloc>().dispose();
    context.read<TimerCubit>().dispose();
    context.read<LiveParticipantsBloc>().close();
    context.read<LiveKitService>().dispose();
    context.read<ChatBloc>().close();
  }
}
