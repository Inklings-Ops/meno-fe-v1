import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveForYouSectionWidget extends WatchingWidget {
  const LiveForYouSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcasts = [fakeLiveBroadcast];

    return BroadcastSection(
      title: Row(
        children: [
          const MText('Live For You'),
          Spaces.horizontalSmall,
          Assets.images.sparkles.image(height: 24, width: 24),
        ],
      ),
      broadcasts: broadcasts,
      itemBuilder: (ctx, broadcast) => LiveBroadcastCard(broadcast: broadcast),
    );
  }
}
