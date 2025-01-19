import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveBroadcastActivityCard extends StatelessWidget {
  const LiveBroadcastActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select<BroadcastBloc, Broadcast>(
      (bloc) => bloc.state.broadcast,
    );

    return BlocBuilder<LiveBloc, LiveState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        live: () => ActivityCard(
          badgeTitle: 'Now Live',
          broadcast: broadcast,
          actionButtonLabel: 'End',
          action: () => onBroadcastEnd(context, broadcast.id),
          onTap: () => router.push<void>(Routes.broadcastTab),
        ),
        reconnecting: () => ActivityCard(
          badgeTitle: 'Reconnecting',
          broadcast: broadcast,
          actionButtonLabel: 'End',
          onTap: () => router.push<void>(Routes.broadcastTab),
        ),
      ),
    );
  }

  void onBroadcastEnd(BuildContext context, Uid<Broadcast> broadcastId) {
    final socket = context.read<SocketBloc>();
    final livekit = context.read<LiveKitBloc>();
    context.showEndBroadcastDialog().then((value) {
      if (value == null || value == false) {
        return;
      } else {
        di<BackgroundService>().stopBroadcastBackgroundProcess();
        socket.add(SocketEndBroadcast(broadcastId));
        livekit.add(const LiveKitDisconnect());
        return;
      }
    });
  }
}
