import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class NowLiveBroadcastsWidget extends StatelessWidget {
  const NowLiveBroadcastsWidget({super.key});

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
          orElse: () => const Padding(
            padding: EdgeInsets.only(top: 120),
            child: EmptyListWidget(),
          ),
          loading: () => _List(broadcasts: fakeBroadcasts, loading: true),
          loaded: (broadcasts) => _List(broadcasts: broadcasts),
          loadingMore: (broadcasts) => Column(
            children: [
              _List(broadcasts: broadcasts),
              Spaces.verticalXLarge,
              const MLoadingIndicator.box(),
            ],
          ),
          loadedLast: (broadcasts) => Column(
            children: [
              _List(broadcasts: broadcasts),
              Spaces.verticalXLarge,
              MText(
                'You’ve reached the end 🎉',
                style: MTextTheme.of(context)!.captionRegular,
                color: MColorScheme.of(context)!.onBackgroundVariant,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
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
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 159.50 / 176,
        ),
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        itemBuilder: (context, i) {
          final broadcast = broadcasts[i]!;
          return MCard.live(
            title: broadcast.title.getOr(),
            imageUrl: broadcast.imageUrl,
            host: broadcast.creator?.fullName ??
                broadcast.fullName ??
                broadcast.creatorFullName ??
                '',
            liveCount: broadcast.totalListeners,
            onTap: () => context.showJoinLiveBroadcastModal(broadcast),
          );
        },
        itemCount: broadcasts.length,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
