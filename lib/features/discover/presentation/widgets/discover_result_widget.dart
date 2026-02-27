import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/presentation/widgets/live_broadcast_card.dart';
import 'package:meno/features/discover/domain/domain.dart';
import 'package:meno/features/discover/presentation/presentation.dart';
import 'package:meno/shared/presentation/widgets/empty_list_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverResultWidget extends StatelessWidget {
  const DiscoverResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DiscoverBroadcastGridView(
      broadcasts: fakeBroadcasts,
      filter: Filter.all,
    );
  }
}

class _AllBroadcastsView extends StatelessWidget {
  const _AllBroadcastsView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spaces.verticalXLarge,
        _Grid(broadcasts: fakeBroadcasts, title: 'Now Live'),
        Spaces.verticalXXLarge,
        _Grid(broadcasts: fakeBroadcasts, title: 'Recently Live'),
        Spaces.verticalXXLarge,
      ],
    );
  }
}

class _Grid extends StatelessWidget {
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
                    host:
                        broadcast.fullName?.getOrNull() ??
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
