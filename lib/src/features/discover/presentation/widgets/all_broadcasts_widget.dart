import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class AllBroadcastsWidget extends StatelessWidget {
  const AllBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spaces.verticalXLarge,
        BlocBuilder<DAllCubit, DAllState>(
          buildWhen: (p, c) =>
              p.isNowLiveLoading != c.isNowLiveLoading ||
              p.nowLive != c.nowLive,
          builder: (context, state) => _Grid(
            title: 'Now Live',
            onSeeAll: () {},
            broadcasts: state.nowLive,
            isLoading: state.isNowLiveLoading,
            isNowLive: true,
          ),
        ),
        Spaces.verticalXXLarge,
        BlocBuilder<DAllCubit, DAllState>(
          buildWhen: (p, c) =>
              p.isRecentlyLiveLoading != c.isRecentlyLiveLoading ||
              p.recentlyLive != c.recentlyLive,
          builder: (context, state) => _Grid(
            title: 'Recently Live',
            onSeeAll: () => context.push(Routes.recentlyLive),
            broadcasts: state.recentlyLive,
            isLoading: state.isRecentlyLiveLoading,
          ),
        ),
        Spaces.verticalXXLarge,
      ],
    );
  }
}

class _Grid extends HookWidget {
  const _Grid({
    required this.title,
    required this.onSeeAll,
    required this.broadcasts,
    required this.isLoading,
    this.isNowLive = false,
  });
  final String title;
  final VoidCallback onSeeAll;
  final List<Broadcast?> broadcasts;
  final bool isLoading;
  final bool isNowLive;
  @override
  Widget build(BuildContext context) {
    late Widget child;
    if (isLoading) {
      child = const MLoadingIndicator.box();
    } else if (!isLoading && broadcasts.isEmpty) {
      child = const EmptyListWidget();
    } else {
      child = GridView.builder(
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
            return MCard.live(
              title: broadcast.title.getOr(),
              imageUrl: broadcast.imageUrl,
              host: broadcast.fullName,
              liveCount: broadcast.totalListeners,
              onTap: () => context.showJoinLiveBroadcastModal(broadcast),
            );
          } else {
            return MCard.recentlyLive(
              title: broadcast.title.getOr(),
              imageUrl: broadcast.imageUrl,
              host: broadcast.fullName,
              onTap: () => context.push(Routes.details, extra: broadcast),
            );
          }
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(title: title, onSeeAll: onSeeAll),
        Spaces.verticalXLarge,
        LimitedBox(maxHeight: 376, child: child),
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
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: Insets.large),
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
