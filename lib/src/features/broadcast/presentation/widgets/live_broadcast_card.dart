import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveBroadcastCard extends StatelessWidget {
  const LiveBroadcastCard({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final liveState = context.watch<BroadcastBloc>().state;
    final myUserId = context.select(
      (SessionBloc bloc) => bloc.state.whenOrNull(
        authenticated: (user, token) => user.id.getOr(),
      ),
    );

    final isHost = myUserId == (broadcast.creatorId ?? broadcast.creator?.id);
    final isBroadcast = broadcast.id == liveState.broadcast.id;
    final isBroadcasting = isHost && !liveState.isStream && isBroadcast;
    final isStreaming = liveState.isStream && isBroadcast;

    return MCard.live(
      title: broadcast.title.getOr(),
      host: hostName,
      imageUrl: broadcast.imageUrl,
      liveCount: broadcast.totalListeners,
      onTap: () {
        if (isBroadcasting) {
          router.push(Routes.broadcastTab);
        } else if (isStreaming) {
          router.push(Routes.broadcastTab, extra: true);
        } else {
          router.push(Routes.preStreamModal, extra: broadcast);
        }
      },
    );
  }


  String get hostName {
    return broadcast.creator?.fullName ??
        broadcast.fullName ??
        broadcast.creatorFullName ??
        '';
  }
}
