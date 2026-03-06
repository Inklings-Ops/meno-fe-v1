import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/_shared/widgets/feed_widget.dart';
import 'package:meno/features/broadcast/widgets/widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomeRecentlyLiveSection extends WatchingWidget {
  const HomeRecentlyLiveSection({required this.feedSource, super.key});
  final BroadcastFeedDataSource feedSource;

  @override
  Widget build(BuildContext context) {
    final params = BroadcastQuery.recentlyLive().toRouterParams;

    return HomeBroadcastSectionWidget(
      title: Row(
        children: [
          const MText('Recently Live'),
          Spaces.horizontalSmall,
          Assets.images.highVoltage.image(height: 24, width: 24),
        ],
      ),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();

          return MCard.recentlyLive(
            key: ValueKey(broadcast.id.getOrCrash()),
            title: broadcast.title.getOrCrash(),
            host: broadcast.effectiveCreatorName.getOrElse((_) => ''),
            imageUrl: broadcast.imageUrl,
            onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
          );
        },
      ),
    );
  }
}
