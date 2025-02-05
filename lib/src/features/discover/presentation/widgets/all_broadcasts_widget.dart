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
        BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const EmptyListWidget(),
            loading: () => _Grid(
              broadcasts: fakeBroadcasts,
              loading: true,
              isNowLive: true,
            ),
            loaded: (broadcasts) => _Grid(
              broadcasts: broadcasts,
              isNowLive: true,
            ),
          ),
        ),
        Spaces.verticalXXLarge,
        BlocBuilder<RecentlyLiveCubit, RecentlyLiveState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const EmptyListWidget(),
            loading: () => _Grid(broadcasts: fakeBroadcasts, loading: true),
            success: (broadcasts) => _Grid(broadcasts: broadcasts),
          ),
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
        ? router.push(Routes.nowLive)
        : router.push(Routes.recentlyLive);
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

                if (isNowLive) {
                  return LiveBroadcastCard(broadcast: broadcast);
                } else {
                  return MCard.recentlyLive(
                    title: broadcast.title.getOr(),
                    imageUrl: broadcast.imageUrl,
                    host: broadcast.creator?.fullName ??
                        broadcast.fullName ??
                        broadcast.creatorFullName ??
                        '',
                    onTap: () => router.push(Routes.details, extra: broadcast),
                  );
                }
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
