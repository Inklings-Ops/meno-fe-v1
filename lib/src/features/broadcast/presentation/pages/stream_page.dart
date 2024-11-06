import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class StreamPage extends HookWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memoize broadcast to avoid re-initializing on every rebuild.
    final b = useMemoized(() => context.read<StreamBloc>().state.broadcast);

    useEffect(
      () {
        context.read<ChatBloc>().add(ChatInitialized(b));
        context.read<ParticipantsBloc>().add(ParticipantsInitialized(b));
        context.read<TimerCubit>().setAndStart(b.startTime);
        context.read<MenoBloc>().update(const MStreaming());
        return null;
      },
      [b],
    );

    return BlocListener<StreamBloc, StreamState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        state.status.whenOrNull(
          failed: context.showBroadcastError,
          left: () => _handleStreamEnd(context),
          streamEnded: (data) => _handleStreamEnd(context),
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
    
    context.read<StreamBloc>().add(const StreamReset());
    context.read<ParticipantsBloc>().add(const ParticipantsReset());
    context.read<ChatBloc>().add(const ChatReset());

    di<LiveKitService>().dispose();
    context.read<TimerCubit>().dispose();
  }
}
