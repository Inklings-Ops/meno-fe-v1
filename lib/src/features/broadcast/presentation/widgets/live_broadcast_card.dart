import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveBroadcastCard extends StatelessWidget {
  const LiveBroadcastCard({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final live = context.watch<LiveBloc>().state;
    final broadcastBloc = context.read<BroadcastBloc>();

    return MCard.live(
      title: broadcast.title.getOr(),
      host: hostName,
      imageUrl: broadcast.imageUrl,
      liveCount: broadcast.totalListeners,
      onTap: () {
        if (isHost(context)) {
          live.maybeWhen(
            orElse: () => broadcastBloc.add(const BroadcastEvent.reconnect()),
            live: () => router.push(Routes.broadcastTab),
            reconnecting: () => router.push(Routes.broadcastTab),
          );
          return;
        } else {
          live.maybeWhen(
            orElse: () => router.push(Routes.preStreamModal, extra: broadcast),
            streaming: () => router.push(Routes.broadcastTab, extra: true),
            reconnecting: () => router.push(Routes.broadcastTab, extra: true),
          );
          return;
        }
      },
    );
  }

  bool isHost(BuildContext context) {
    final session = context.read<SessionBloc>().state;
    final myUid = session.whenOrNull(authenticated: (u, _) => u.id.getOr());
    return broadcast.creatorId == myUid || broadcast.creator?.id == myUid;
  }

  String get hostName {
    return broadcast.creator?.fullName ??
        broadcast.fullName ??
        broadcast.creatorFullName ??
        '';
  }
}
