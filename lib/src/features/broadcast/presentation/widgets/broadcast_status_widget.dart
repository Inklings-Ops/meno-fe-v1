import 'package:meno_fe_v1/meno.dart';

class BroadcastStatusWidget extends StatelessWidget {
  final bool isStreaming;
  const BroadcastStatusWidget({super.key, this.isStreaming = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenoBloc, MenoState>(
      bloc: context.watch<MenoBloc>(),
      builder: (context, state) => state.when(
        live: () =>  MBadge.live(),
        reconnecting: () => MBadge.reconnecting(context),
        streaming: () =>  MBadge.live(),
        offAir: () => MBadge.offAir(context),
        endedBroadcast: (_) => MBadge.offAir(context),
        leaveBroadcast: () => MBadge.offAir(context),
        leftBroadcast: (_) =>  MBadge.live(),
      ),
    );
  }
}
