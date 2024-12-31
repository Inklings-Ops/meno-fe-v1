import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class NowLive extends StatelessWidget {
  const NowLive({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveBroadcastsBloc>();
    return BlocListener<SocketBloc, SocketState>(
      listener: (context, state) {
        state.whenOrNull(
          newBroadcast: (data) => bloc.add(NewBroadcastReceived(data)),
          endedBroadcast: (data) => bloc.add(EndedBroadcastReceived(data)),
        );
      },
      child: BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
        builder: (context, state) => state.maybeWhen(
          orElse: () => const _BuildColumn(child: EmptyListWidget()),
          loading: () => const _BuildColumn(child: _SkeletonLoader()),
          success: (broadcasts) => _BuildColumn(
            showSeeAllButton: true,
            child: BroadcastListWidget(
              itemBuilder: (context, i) => _LiveCard(broadcast: broadcasts[i]!),
              itemCount: broadcasts.length,
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveCard extends HookWidget {
  const _LiveCard({required this.broadcast});

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

class _BuildColumn extends StatelessWidget {
  const _BuildColumn({required this.child, this.showSeeAllButton = false});

  final Widget child;
  final bool showSeeAllButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            onTap: showSeeAllButton ? () {} : null,
            child: MText(
              'See all',
              color: MColorScheme.of(context)!.onBackgroundVariant,
            ),
          ),
        ),
        const SizedBox(height: 24),
        LimitedBox(maxHeight: 184, child: child),
      ],
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return BroadcastListWidget(
      itemCount: 3,
      itemBuilder: (context, i) => MCard.live(loading: true),
    );
  }
}
