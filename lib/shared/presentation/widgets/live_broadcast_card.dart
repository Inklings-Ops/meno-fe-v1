import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveBroadcastCard extends WatchingWidget {
  const LiveBroadcastCard({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    // final liveState = fakeBroadcasts[0];

    // final currentUserId = watchValue((UserManager m) => m.currentUserId);
    //
    // final isHost = currentUserId.fold(
    //   () => false,
    //   (userId) => userId == broadcast.effectiveCreatorId,
    // );

    // final isBroadcast = broadcast.id == liveState.broadcast.id;
    // final isBroadcasting = isHost && !liveState.isStream && isBroadcast;
    // final isStreaming = liveState.isStream && isBroadcast;

    return MCard.live(
      title: broadcast.title.getOrCrash(),
      host: broadcast.effectiveCreatorName.getOrElse((_) => ''),
      imageUrl: broadcast.imageUrl,
      liveCount: broadcast.totalListeners,
      onTap: () {
        // if (isBroadcasting) {
        //   context.push(R.broadcastTab);
        // } else if (isStreaming) {
        //   context.push(R.broadcastTab, extra: true);
        // } else {
        //   // context.push(R.preStreamModal, extra: broadcast);
        // }
        PreStreamModal.show(context, broadcast);
      },
    );
  }
}
