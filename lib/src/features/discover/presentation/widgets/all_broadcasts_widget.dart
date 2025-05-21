import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class AllBroadcastsWidget extends StatelessWidget {
  const AllBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spaces.verticalXLarge,
        BlocBuilder<NowLiveBloc, NowLiveState>(
          builder: (context, state) {
            switch (state) {
              case NowLiveLoadInProgress():
              case NowLiveLoadMoreInProgress():
                return _Grid(
                  broadcasts: fakeBroadcasts,
                  loading: true,
                  isNowLive: true,
                );
              case NowLiveLoadSuccess(:final broadcasts):
                return _Grid(broadcasts: broadcasts, isNowLive: true);
              default:
                return const EmptyListWidget();
            }
          },
        ),
        Spaces.verticalXXLarge,
        BlocBuilder<RecentlyLiveBloc, RecentlyLiveState>(
          builder: (context, state) {
            switch (state) {
              case RecentlyLiveLoadInProgress():
              case RecentlyLiveLoadMoreInProgress():
                return _Grid(broadcasts: fakeBroadcasts, loading: true);
              case RecentlyLiveLoadSuccess(:final broadcasts):
                return _Grid(broadcasts: broadcasts);
              default:
                return const EmptyListWidget();
            }
          },
        ),
        Spaces.verticalXXLarge,
      ],
    );
  }
}

class _Grid extends HookWidget {
  const _Grid({
    required this.broadcasts,
    this.loading = false,
    this.isNowLive = false,
  });

  final List<Broadcast?> broadcasts;
  final bool loading;
  final bool isNowLive;

  @override
  Widget build(BuildContext context) {
    final title = isNowLive ? 'Now Live' : 'Recently Live';
    void onSeeAll() => isNowLive
        ? router.pushNamed(
            'Broadcasts',
            queryParameters: {
              'type': BroadcastsPageType.now.name,
              'sort-by': 'startTime',
              'order-by': OrderBy.ASC.name,
              'end-time-exists': 'false',
              'start-time-exists': 'true',
              'include': 'totalListeners',
              'status': 'active',
            },
          )
        : router.pushNamed(
            'Broadcasts',
            queryParameters: {
              'type': BroadcastsPageType.recently.name,
              'sort-by': 'endTime',
              'order-by': OrderBy.DESC.name,
              'end-time-exists': 'true',
              'include': 'totalListeners',
            },
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(title: title, onSeeAll: onSeeAll),
        Spaces.verticalXLarge,
        LimitedBox(
          maxHeight: 376,
          child: Skeletonizer(
            enabled: loading,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              primary: false,
              itemCount: broadcasts.length,
              itemBuilder: (context, index) {
                final broadcast = broadcasts[index]!;
                if (isNowLive) return LiveBroadcastCard(broadcast: broadcast);
                return MCard.recentlyLive(
                  title: broadcast.title.getOr(),
                  imageUrl: broadcast.imageUrl,
                  host: broadcast.creator?.fullName ??
                      broadcast.fullName ??
                      broadcast.creatorFullName ??
                      '',
                  onTap: () => router.pushNamed(
                    'Broadcast Details',
                    pathParameters: {'id': broadcast.id.getOr()},
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MText(title, style: textTheme.subheadingBold),
          InkWell(
            onTap: onSeeAll,
            child: MText(
              'See all',
              style: textTheme.microMedium,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
