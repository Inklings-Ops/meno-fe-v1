import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';

class LiveBroadcastActivityCard extends WatchingWidget {
  const LiveBroadcastActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserIdOption = watchValue((UserManager m) => m.currentUserId);
    final currentUserId = currentUserIdOption.toNullable();
    if (currentUserId == null) return const SizedBox.shrink();

    final snapshot = watchStream(
      (IBroadcastRepository repo) => repo.watchActiveSession(currentUserId),
      initialValue: BroadcastSession.empty,
    );

    final session = snapshot.data;
    if (session == null || !session.isValid) return const SizedBox.shrink();

    if (!allReady()) return const SizedBox.shrink();

    final broadcast = session.broadcast;

    final status = watchValue((LiveSessionManager m) => m.liveStatus);
    final showCard = status == .live || status == .reconnecting;
    if (!showCard) return const SizedBox.shrink();

    if (currentUserId == broadcast.effectiveCreatorId) {
      return ActivityCard(
        badgeTitle: switch (status) {
          .live => 'Now Live',
          .reconnecting => 'Reconnecting',
          _ => '',
        },
        broadcast: broadcast,
        actionButtonLabel: 'End',
        action: () => onBroadcastEnd(context, broadcast.id),
        onTap: () => context.push<void>(R.broadcastTab),
      );
    } else {
      return ActivityCard(
        badgeTitle: switch (status) {
          .live => 'Now Streaming',
          .reconnecting => 'Reconnecting',
          _ => '',
        },
        broadcast: broadcast,
        actionButtonLabel: 'Leave',
        action: () => onBroadcastLeave(context, broadcast.id),
        onTap: () => context.push<void>(R.broadcastTab, extra: true),
      );
    }
  }

  Future<void> onBroadcastEnd(BuildContext context, Id broadcastId) async {
    final result = await BroadcastExitAlertDialog.show(context);
    if (result != true) return;
    di<LiveSessionManager>().endSession.run();
  }

  Future<void> onBroadcastLeave(BuildContext context, Id broadcastId) async {
    // final broadcastBloc = context.read<BroadcastBloc>();
    // context.showLeaveBroadcastDialog().then((result) {
    //   if (result != true) return;
    //   broadcastBloc.add(BroadcastEndRequested(broadcastId));
    //   return;
    // });
  }
}
