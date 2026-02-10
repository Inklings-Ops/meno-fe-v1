import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveBroadcastCard extends WatchingWidget {
  const LiveBroadcastCard({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    // TODO(gettoknowdavid): Handle fake live state
    // final liveState = fakeBroadcasts[0];

    // final currentUserId = watchValue((UserManager m) => m.currentUserId);

    // final isHost = currentUserId.fold(
    //   () => false,
    //   (userId) => userId == (broadcast.creatorId ?? broadcast.creator?.id),
    // );

    // final isBroadcast = broadcast.id == liveState.broadcast.id;
    // final isBroadcasting = isHost && !liveState.isStream && isBroadcast;
    // final isStreaming = liveState.isStream && isBroadcast;

    return MCard.live(
      title: broadcast.title.getOrCrash(),
      host: hostName,
      imageUrl: broadcast.imageUrl,
      liveCount: broadcast.totalListeners,
      onTap: () {
        // if (isBroadcasting) {
        //   context.push(R.broadcastTab);
        // } else if (isStreaming) {
        //   context.push(R.broadcastTab, extra: true);
        // } else {
        //   // TODO(gettoknowdavid): Handle pre stream modal
        //   // context.push(R.preStreamModal, extra: broadcast);
        // }
      },
    );
  }

  String get hostName {
    return broadcast.creator?.fullName.getOrCrash() ??
        broadcast.fullName?.getOrCrash() ??
        broadcast.creatorFullName?.getOrCrash() ??
        '';
  }
}
