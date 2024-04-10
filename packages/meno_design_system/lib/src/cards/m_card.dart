import 'package:flutter/material.dart';

import 'm_live_card.dart';
import 'm_recently_live_card.dart';
import 'm_styled_card.dart';

class MCard extends MStyledCard {
  factory MCard.live({
    Key? key,
    String title,
    String host,
    String? imageUrl,
    int? liveCount,
    VoidCallback? onTap,
    bool loading,
  }) = _LiveCard;

  factory MCard.recentlyLive({
    Key? key,
    String title,
    String? host,
    String? imageUrl,
    VoidCallback? onTap,
    bool loading,
  }) = _RecentlyLiveCard;

  const MCard._({
    super.key,
    required super.child,
    required super.title,
    super.subtitle,
    super.onTap,
  });
}

class _LiveCard extends MCard {
  _LiveCard({
    super.key,
    super.title,
    String? host,
    String? imageUrl,
    int? liveCount,
    super.onTap,
    bool loading = false,
  }) : super._(
          child: loading
              ? const MLiveCardSkeleton()
              : MLiveCard(
                  title: title!,
                  host: host!,
                  imageUrl: imageUrl,
                  liveCount: liveCount,
                  onTap: onTap,
                ),
        );
}

class _RecentlyLiveCard extends MCard {
  _RecentlyLiveCard({
    super.key,
    super.title,
    String? host,
    String? imageUrl,
    VoidCallback? onTap,
    bool loading = false,
  }) : super._(
          child: loading
              ? const MRecentlyLiveCardSkeleton()
              : MRecentlyLiveCard(
                  title: title!,
                  host: host!,
                  imageUrl: imageUrl,
                  onTap: onTap,
                ),
        );
}
