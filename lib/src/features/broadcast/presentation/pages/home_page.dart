import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recentlyLiveBloc = context.read<RecentlyLiveCubit>();
    final liveBroadcastsCubit = context.read<LiveBroadcastsBloc>();
    final liveKit = context.read<LiveKitBloc>();

    Future<void> onRefresh() async {
      final liveBroadcasts = liveBroadcastsCubit.stream.first;
      liveBroadcastsCubit.add(const GetLiveBroadcasts());

      final recentlyLive = recentlyLiveBloc.stream.first;
      await recentlyLiveBloc.fetch();

      await Future.wait([liveBroadcasts, recentlyLive]);
    }

    final isStreaming = context.select<LiveBloc, bool>((bloc) {
      return bloc.state.maybeWhen(orElse: () => false, streaming: () => true);
    });

    return MultiBlocListener(
      listeners: [
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              broadcastEnded: () {
                final bId = context.read<BroadcastBloc>().state.broadcast.id;
                context.read<ParticipantsBloc>().add(GetAllParticipants(bId));
                context.read<TimerCubit>().stop();
                context.read<LiveBloc>().add(const LiveReset());
                router.push<void>(Routes.endedBroadcast);
              },
              endedBroadcast: (data) {
                if (!isStreaming) return;
                context.read<LiveBloc>().add(const LiveReset());
                context.read<LiveKitBloc>().add(const LiveKitDisconnect());
                context.read<ParticipantsBloc>().add(const ParticipantsReset());
                context.read<ChatListBloc>().add(const ChatReset());
                context.read<StreamBloc>().add(const StreamReset());
                context.read<TimerCubit>().dispose();
                context.showErrorSnackBar(data.reason.message);
              },
              broadcastLeft: () {
                context.read<LiveBloc>().add(const LiveReset());
                context.read<ParticipantsBloc>().add(const ParticipantsReset());
                context.read<ChatListBloc>().add(const ChatReset());
                context.read<StreamBloc>().add(const StreamReset());
                context.read<TimerCubit>().dispose();
              },
            );
          },
        ),
        BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            state.status.whenOrNull(
              failure: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showBroadcastError(error);
              },
            );
          },
        ),
      ],
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              children: [
                BlocBuilder<LiveBloc, LiveState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => Spaces.verticalXLarge,
                    streaming: LiveStreamActivityCard.new,
                    live: LiveBroadcastActivityCard.new,
                  ),
                ),
                const LiveForYou(),
                const NowLiveSection(),
                const RecentlyLiveSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
