import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveBroadcastActivityCard extends StatelessWidget {
  const LiveBroadcastActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select<BroadcastBloc, Broadcast>(
      (bloc) => bloc.state.broadcast,
    );

    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) {
        switch (state.status) {
          case LiveBroadcastStatus.reconnecting:
          case LiveBroadcastStatus.started:
            return ActivityCard(
              badgeTitle: 'Now Live',
              broadcast: broadcast,
              actionButtonLabel: 'End',
              action: () => onBroadcastEnd(context, broadcast.id),
              onTap: () => router.push<void>(Routes.broadcastTab),
            );
          case LiveBroadcastStatus.joined:
            return ActivityCard(
              badgeTitle: 'Now Streaming',
              broadcast: broadcast,
              actionButtonLabel: 'Leave',
              action: () => onBroadcastLeave(context, broadcast.id),
              onTap: () => router.push<void>(Routes.broadcastTab, extra: true),
            );
          case LiveBroadcastStatus.failure:
          case LiveBroadcastStatus.initial:
          case LiveBroadcastStatus.left:
          case LiveBroadcastStatus.loading:
          case LiveBroadcastStatus.ended:
          case LiveBroadcastStatus.offAir:
            return const SizedBox(height: Insets.xxl);
        }
      },
    );
  }

  void onBroadcastEnd(BuildContext context, ID broadcastId) {
    final broadcastBloc = context.read<BroadcastBloc>();
    context.showEndBroadcastDialog().then((result) {
      if (result != true) return;
      broadcastBloc.add(BroadcastEndRequested(broadcastId));
      return;
    });
  }

  void onBroadcastLeave(BuildContext context, ID broadcastId) {
    final broadcastBloc = context.read<BroadcastBloc>();
    context.showLeaveBroadcastDialog().then((result) {
      if (result != true) return;
      broadcastBloc.add(BroadcastEndRequested(broadcastId));
      return;
    });
  }
}
