import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class DiscoverResultWidget extends HookWidget {
  const DiscoverResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      buildWhen: (p, c) => p.filter != c.filter || p.isLoading != c.isLoading,
      builder: (context, state) {
        final isLoading = state.isLoading;
        final filter = state.filter;

        if (filter == Filter.all) return const _AllBroadcastsView();

        if (!isLoading && (state.searchMap[filter]?.isEmpty ?? false)) {
          return const Center(child: EmptyListWidget());
        }

        final broadcasts = state.searchMap[filter] ?? [];
        return DiscoverBroadcastGridView(
          broadcasts: broadcasts,
          filter: filter,
        );
      },
    );
  }
}

class _AllBroadcastsView extends HookWidget {
  const _AllBroadcastsView();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spaces.verticalXLarge,
        BlocBuilder<NowLiveBloc, NowLiveState>(
          builder: (context, state) {
            switch (state) {
              case NowLiveLoadFailure():
                return const EmptyListWidget();
              case NowLiveLoadMoreInProgress(:final broadcasts):
              case NowLiveLoadSuccess(:final broadcasts):
                return _Grid(
                  title: 'Now Live',
                  broadcasts: broadcasts,
                  isNowLive: true,
                  onSeeAll: () {},
                );
              case NowLiveInitial():
              case NowLiveLoadInProgress():
                return _Grid(
                  title: 'Now Live',
                  broadcasts: fakeBroadcasts,
                  isNowLive: true,
                  isLoading: true,
                );
            }
          },
        ),
        Spaces.verticalXXLarge,
        BlocBuilder<RecentlyLiveBloc, RecentlyLiveState>(
          builder: (context, state) {
            switch (state) {
              case RecentlyLiveLoadFailure():
                return const EmptyListWidget();
              case RecentlyLiveLoadMoreInProgress(:final broadcasts):
              case RecentlyLiveLoadSuccess(:final broadcasts):
                return _Grid(
                  title: 'Recently Live',
                  broadcasts: broadcasts,
                  onSeeAll: () {},
                );
              case RecentlyLiveInitial():
              case RecentlyLiveLoadInProgress():
                return _Grid(
                  title: 'Recently Live',
                  broadcasts: fakeBroadcasts,
                  isLoading: true,
                );
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
    required this.title,
    required this.broadcasts,
    this.onSeeAll,
    this.isNowLive = false,
    this.isLoading = false,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final List<Broadcast?> broadcasts;
  final bool isNowLive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    if (!isLoading && broadcasts.isEmpty) return const EmptyListWidget();

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MText(title, style: textTheme.subheadingBold),
                InkWell(
                  onTap: isLoading ? null : onSeeAll,
                  child: MText(
                    'See all',
                    style: textTheme.microMedium,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
          Spaces.verticalXLarge,
          LimitedBox(
            maxHeight: 376,
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
              itemBuilder: (context, i) {
                final broadcast = broadcasts[i]!;
                if (isNowLive) {
                  return LiveBroadcastCard(broadcast: broadcast);
                } else {
                  return MCard.recentlyLive(
                    title: broadcast.title.getOrCrash(),
                    imageUrl: broadcast.imageUrl,
                    host: broadcast.fullName?.getOrNull() ??
                        broadcast.creatorFullName?.getOrNull() ??
                        broadcast.creator?.fullName.getOrNull(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
