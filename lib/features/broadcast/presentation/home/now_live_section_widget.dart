import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

typedef _NLBManager = NowLiveBroadcastsManager;

class NowLiveSectionWidget extends WatchingWidget {
  const NowLiveSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<NowLiveBroadcastsManager>();
    final broadcasts = watchValue((_NLBManager m) => m.broadcasts);
    final isLoading = watchValue((_NLBManager m) => m.initialize.isRunning);
    final error = watchValue((_NLBManager m) => m.error);

    final params = BroadcastQuery.nowLive().toRouterParams;

    return BroadcastSection(
      title: Row(
        children: [
          const MText('Now Live'),
          Spaces.horizontalSmall,
          Assets.images.flame.image(height: 24, width: 24),
        ],
      ),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      error: error,
      onRetry: manager.initialize.runAsync,
      isLoading: isLoading,
      broadcasts: isLoading ? fakeBroadcasts : broadcasts,
      itemBuilder: (ctx, broadcast) => LiveBroadcastCard(broadcast: broadcast),
    );
  }
}
