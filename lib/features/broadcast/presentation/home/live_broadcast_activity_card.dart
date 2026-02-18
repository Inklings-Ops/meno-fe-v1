import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';

class LiveBroadcastActivityCard extends WatchingWidget {
  const LiveBroadcastActivityCard({required this.currentUserId, super.key});

  final Id currentUserId;

  @override
  Widget build(BuildContext context) {
    final isReady = watchFuture<GetIt, void>(
      (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
      target: di,
      initialValue: null,
    );

    final session = watchStream(
      (IBroadcastRepository repo) => repo.watchActiveSession(currentUserId),
      initialValue: BroadcastSession.empty,
    );

    if (!isReady.hasData || !session.hasData) return const SizedBox.shrink();
    if (session.data == null) return const SizedBox.shrink();

    callOnceAfterThisBuild(
      (_) async => Future.delayed(const Duration(seconds: 5), di.allReady),
    );

    return _ViewWidget(
      key: key,
      broadcast: session.data!.broadcast,
      currentUserId: currentUserId,
    );
  }
}

class _ViewWidget extends WatchingWidget {
  const _ViewWidget({
    required this.broadcast,
    required this.currentUserId,
    super.key,
  });

  final Broadcast broadcast;
  final Id currentUserId;

  @override
  Widget build(BuildContext context) {
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
