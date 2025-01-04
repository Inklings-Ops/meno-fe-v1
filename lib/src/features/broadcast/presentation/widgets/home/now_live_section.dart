import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NowLiveSection extends StatelessWidget {
  const NowLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<LiveBroadcastsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            onTap: () => context.push(Routes.nowLive),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        const SizedBox(height: 24),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              newBroadcast: (data) => bloc.add(NewBroadcastReceived(data)),
              endedBroadcast: (data) => bloc.add(EndedBroadcastReceived(data)),
            );
          },
          child: LimitedBox(
            maxHeight: 184,
            child: BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
              builder: (context, state) => state.maybeWhen(
                orElse: EmptyListWidget.new,
                loading: () => _List(broadcasts: fakeBroadcasts, loading: true),
                loaded: (broadcasts) => _List(broadcasts: broadcasts),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends HookWidget {
  const _Card({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final live = context.watch<LiveBloc>();
    final session = context.read<SessionCubit>().state;
    return MCard.live(
      title: broadcast.title.getOr(),
      host: broadcast.creator?.fullName ??
          broadcast.fullName ??
          broadcast.creatorFullName ??
          '',
      imageUrl: broadcast.imageUrl,
      liveCount: broadcast.totalListeners,
      onTap: () {
        live.state.maybeWhen(
          orElse: () {
            final myUid = session.whenOrNull(
              authenticated: (user, _) => user.id.getOr(),
            );
            if (broadcast.creatorId == myUid) return;
            context.showJoinLiveBroadcastModal(broadcast);
          },
          live: () => router.push(Routes.broadcastTab, extra: broadcast),
          streaming: () => router.push(Routes.broadcastTab, extra: true),
          reconnecting: () => router.push(Routes.broadcastTab, extra: true),
        );
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, super.key, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: broadcasts.length,
        itemBuilder: (_, i) => _Card(broadcast: broadcasts[i]!),
        primary: false,
        shrinkWrap: true,
      ),
    );
  }
}
