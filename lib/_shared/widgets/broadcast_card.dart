import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastCard extends StatelessWidget {
  const BroadcastCard._(
    this.broadcast, {
    required this.onTap,
    required this.type,
    super.key,
  });

  const BroadcastCard.live(
    Broadcast broadcast, {
    required VoidCallback onTap,
    Key? key,
  }) : this._(broadcast, onTap: onTap, type: .live, key: key);

  const BroadcastCard.recentlyLiveCard(
    Broadcast broadcast, {
    required VoidCallback onTap,
    Key? key,
  }) : this._(broadcast, onTap: onTap, type: .rCard, key: key);

  const BroadcastCard.tile(
    Broadcast broadcast, {
    required VoidCallback onTap,
    Key? key,
  }) : this._(broadcast, onTap: onTap, type: .rTile, key: key);

  final Broadcast broadcast;
  final VoidCallback onTap;
  final _CardType type;

  @override
  Widget build(BuildContext context) {
    final title = broadcast.title.getOrCrash();
    final creator = broadcast.effectiveCreatorName.getOrElse((_) => '');
    final imageUrl = broadcast.imageUrl;
    final liveCount = broadcast.totalListeners;
    final endTime = broadcast.endTime;

    return switch (type) {
      _CardType.live => MCard.live(
        key: key,
        title: title,
        host: creator,
        imageUrl: imageUrl,
        liveCount: liveCount,
        onTap: onTap,
      ),
      _CardType.rCard => MCard.recentlyLive(
        key: key,
        title: title,
        host: creator,
        imageUrl: imageUrl,
        onTap: onTap,
      ),
      _CardType.rTile => MRecentlyLiveListTile(
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

enum _CardType { live, rCard, rTile }
