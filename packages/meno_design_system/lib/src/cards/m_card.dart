import 'package:flutter/material.dart';

import 'm_live_card.dart';
import 'm_recently_live_card.dart';
import 'm_styled_card.dart';

class MCard extends MStyledCard {
  const MCard._({
    Key? key,
    required super.child,
    required super.title,
    super.subtitle,
  }) : super(key: key);

  factory MCard.live({
    Key? key,
    required String title,
    required String host,
    String? imageUrl,
  }) = _LiveCard;

  factory MCard.recentlyLive({
    Key? key,
    required String title,
    required String host,
    String? imageUrl,
  }) = _RecentlyLiveCard;
}

class _LiveCard extends MCard {
  _LiveCard({
    super.key,
    required super.title,
    required String host,
    String? imageUrl,
    int liveCount = 0,
  }) : super._(
          child: MLiveCard(
            title: title,
            host: host,
            imageUrl: imageUrl,
            liveCount: liveCount,
          ),
        );
}

class _RecentlyLiveCard extends MCard {
  _RecentlyLiveCard({
    super.key,
    required super.title,
    required String host,
    String? imageUrl,
  }) : super._(
          child: MRecentlyLiveCard(
            title: title,
            host: host,
            imageUrl: imageUrl,
          ),
        );
}
