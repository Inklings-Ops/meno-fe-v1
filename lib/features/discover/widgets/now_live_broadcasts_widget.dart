import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/services/_services.dart';
import 'package:meno/features/broadcast/widgets/pre_stream_modal.dart';

class NowLiveBroadcastsWidget extends WatchingWidget {
  const NowLiveBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.nowLive(),
      );
    });

    return FeedWidget(
      feedSource: feedSource,
      gridCrossAxisSpacing: 24,
      gridMainAxisSpacing: 24,
      gridChildAspectRatio: 159.50 / 176,
      layout: .verticalGrid,
      skeletonItem: BroadcastCard.skeletonLive,
      padding: const .fromLTRB(16, 28, 16, 32),
      itemBuilder: (context, broadcast) {
        if (broadcast == null) return const SizedBox.shrink();
        return BroadcastCard.nLive(
          broadcast,
          key: ValueKey(broadcast.id.getOrCrash()),
          onTap: () => PreStreamModal.show(context, broadcast.id),
        );
      },
    );
  }
}
