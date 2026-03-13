import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/services/_services.dart';

class RecentlyLiveBroadcastsWidget extends WatchingWidget {
  const RecentlyLiveBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.recentlyLive(),
      );
    });

    return FeedWidget(
      feedSource: feedSource,
      gridCrossAxisSpacing: 24,
      gridMainAxisSpacing: 24,
      gridChildAspectRatio: 159.50 / 176,
      layout: .verticalGrid,
      padding: const .fromLTRB(16, 28, 16, 32),
      itemBuilder: (context, broadcast) {
        if (broadcast == null) return const SizedBox.shrink();
        return BroadcastCard.rLive(
          broadcast,
          key: ValueKey(broadcast.id.getOrCrash()),
          onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
        );
      },
    );
  }
}
