import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/features/discover/domain/filter.dart';
import 'package:meno/shared/presentation/widgets/empty_list_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverBroadcastGridView extends StatelessWidget {
  const DiscoverBroadcastGridView({
    required this.broadcasts,
    required this.filter,
    super.key,
  });
  final List<Broadcast?> broadcasts;
  final Filter filter;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 159.50 / 176,
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
      itemBuilder: (context, i) {
        final broadcast = broadcasts[i]!;
        return switch (filter) {
          Filter.recentlyLive => _RecentlyLiveCard(broadcast: broadcast),
          Filter.nowLive => _NowLiveCard(broadcast: broadcast),
          _ => const EmptyListWidget(),
        };
      },
      itemCount: broadcasts.length,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class _NowLiveCard extends StatelessWidget {
  const _NowLiveCard({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MCard.live(
      title: broadcast.title.getOrCrash(),
      imageUrl: broadcast.imageUrl,
      host:
          broadcast.creator?.fullName.getOrNull() ??
          broadcast.fullName?.getOrNull() ??
          broadcast.creatorFullName?.getOrNull() ??
          '',
      liveCount: broadcast.totalListeners,
    );
  }
}

class _RecentlyLiveCard extends StatelessWidget {
  const _RecentlyLiveCard({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MCard.recentlyLive(
      title: broadcast.title.getOrCrash(),
      imageUrl: broadcast.imageUrl,
      host:
          broadcast.creator?.fullName.getOrNull() ??
          broadcast.fullName?.getOrNull() ??
          broadcast.creatorFullName?.getOrNull() ??
          '',
    );
  }
}
