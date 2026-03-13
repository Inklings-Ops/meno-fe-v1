import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BroadcastCard extends StatelessWidget {
  const BroadcastCard._(
    this.broadcast, {
    required this.onTap,
    required this.type,
    super.key,
  });

  const BroadcastCard.nLive(
    Broadcast broadcast, {
    required VoidCallback onTap,
    Key? key,
  }) : this._(broadcast, onTap: onTap, type: .nLive, key: key);

  const BroadcastCard.rLive(
    Broadcast broadcast, {
    required VoidCallback onTap,
    Key? key,
  }) : this._(broadcast, onTap: onTap, type: .rLive, key: key);

  const BroadcastCard.rLiveTile(
    Broadcast broadcast, {
    required VoidCallback onTap,
    Key? key,
  }) : this._(broadcast, onTap: onTap, type: .rLiveTile, key: key);

  /// Skeleton placeholder for live/forYou/nowLive horizontal cards.
  ///
  /// Matches the shape of [BroadcastCard.nLive] — wrap with [Skeletonizer]
  /// in FeedWidget and it shimmers automatically.
  static const Widget skeletonLive = _BroadcastCardSkeleton(
    type: _SkeletonType.nLive,
  );

  /// Skeleton placeholder for recentlyLive horizontal cards.
  ///
  /// Matches the shape of [BroadcastCard.rLive].
  static const Widget skeletonRecentlyLive = _BroadcastCardSkeleton(
    type: _SkeletonType.rLive,
  );

  /// Skeleton placeholder for recentlyLive horizontal cards.
  ///
  /// Matches the shape of [BroadcastCard.rLiveTile].
  static const Widget skeletonRecentlyLiveTile = _BroadcastCardSkeleton(
    type: _SkeletonType.rLiveTile,
  );

  final Broadcast broadcast;
  final VoidCallback onTap;
  final _CardType type;

  @override
  Widget build(BuildContext context) {
    final title = broadcast.title.getOrCrash();
    final creator = broadcast.hostName.getOrElse((_) => '');
    final imageUrl = broadcast.imageUrl;
    final liveCount = broadcast.totalListeners;
    final endTime = broadcast.endTime;

    return switch (type) {
      _CardType.nLive => MCard.live(
        key: key,
        title: title,
        host: creator,
        imageUrl: imageUrl,
        liveCount: liveCount,
        onTap: onTap,
      ),
      _CardType.rLive => MCard.recentlyLive(
        key: key,
        title: title,
        host: creator,
        imageUrl: imageUrl,
        onTap: onTap,
      ),
      _CardType.rLiveTile => MRecentlyLiveListTile(
        key: key,
        title: title,
        creator: creator,
        imageUrl: imageUrl,
        endTime: endTime,
        onTap: onTap,
      ),
    };
  }
}

enum _CardType { nLive, rLive, rLiveTile }

enum _SkeletonType { nLive, rLive, rLiveTile }

/// Shape-accurate skeleton for [BroadcastCard].
///
/// Sized to match the 148-wide cards used on the home page horizontal strips.
/// [Skeletonizer] shimmers over every child automatically — no custom painting
/// needed. Strings must be non-empty so the text widgets have measurable size.
class _BroadcastCardSkeleton extends StatelessWidget {
  const _BroadcastCardSkeleton({required this.type});

  final _SkeletonType type;

  @override
  Widget build(BuildContext context) {
    final broadcast = fakeBroadcasts[0];
    return switch (type) {
      _SkeletonType.nLive => Skeletonizer(
        child: MCard.live(
          key: key,
          title: broadcast.title.getOrElse((_) => ''),
          host: broadcast.hostName.getOrElse((_) => ''),
          imageUrl: broadcast.imageUrl,
          liveCount: broadcast.liveListeners,
        ),
      ),
      _SkeletonType.rLive => Skeletonizer(
        child: MCard.recentlyLive(
          key: key,
          title: broadcast.title.getOrElse((_) => ''),
          host: broadcast.hostName.getOrElse((_) => ''),
          imageUrl: broadcast.imageUrl,
        ),
      ),
      _SkeletonType.rLiveTile => Skeletonizer(
        child: MRecentlyLiveListTile(
          key: key,
          title: broadcast.title.getOrElse((_) => ''),
          creator: broadcast.hostName.getOrElse((_) => ''),
          endTime: broadcast.endTime,
          imageUrl: broadcast.imageUrl,
        ),
      ),
    };
  }
}
