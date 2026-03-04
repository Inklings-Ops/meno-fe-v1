import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

typedef _RLBManager = RecentlyLiveBroadcastsManager;

class RecentlyLiveSectionWidget extends WatchingWidget {
  const RecentlyLiveSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<RecentlyLiveBroadcastsManager>();
    final broadcasts = watchValue((_RLBManager m) => m.broadcasts);
    final isLoading = watchValue((_RLBManager m) => m.fetch.isRunning);
    final error = watchValue((_RLBManager m) => m.fetch.errors);

    final params = BroadcastQuery.recentlyLive().toRouterParams;

    return BroadcastSection(
      title: Row(
        children: [
          const MText('Recently Live'),
          Spaces.horizontalSmall,
          Assets.images.highVoltage.image(height: 24, width: 24),
        ],
      ),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      isLoading: isLoading,
      error: error,
      onRetry: manager.fetch.runAsync,
      broadcasts: isLoading ? fakeBroadcasts : broadcasts,
      itemBuilder: (context, broadcast) => MCard.recentlyLive(
        title: broadcast.title.getOrCrash(),
        host: broadcast.effectiveCreatorName.getOrElse((_) => ''),
        imageUrl: broadcast.imageUrl,
        onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
      ),
    );
  }
}
