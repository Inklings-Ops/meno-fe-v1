import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveStreamActivityCard extends StatelessWidget {
  const LiveStreamActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select((StreamBloc bloc) => bloc.state.broadcast);

    return BlocBuilder<LiveBloc, LiveState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        streaming: () => ActivityCard(
          badgeTitle: 'Now Streaming',
          broadcast: broadcast,
          actionButtonLabel: 'Leave',
          action: () => onBroadcastLeave(context, broadcast.id),
          onTap: () => router.push<void>(Routes.broadcastTab, extra: true),
        ),
        reconnecting: () => ActivityCard(
          badgeTitle: 'Reconnecting',
          broadcast: broadcast,
          actionButtonLabel: 'Leave',
          onTap: () => router.push<void>(Routes.broadcastTab, extra: true),
        ),
      ),
    );
  }

  void onBroadcastLeave(BuildContext context, Uid<Broadcast> broadcastId) {
    final socket = context.read<SocketBloc>();
    final livekit = context.read<LiveKitBloc>();
    context.showLeaveBroadcastDialog().then((value) {
      if (value == null || value == false) {
        return;
      } else {
        di<BackgroundService>().stopBroadcastBackgroundProcess();
        socket.add(SocketLeaveBroadcast(broadcastId));
        livekit.add(const LiveKitDisconnect());
        return;
      }
    });
  }
}
