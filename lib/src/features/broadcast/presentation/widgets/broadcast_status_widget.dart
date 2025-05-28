import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastStatusWidget extends HookWidget {
  const BroadcastStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<LiveBloc, LiveState>(
    //   bloc: context.watch<LiveBloc>(),
    //   builder: (context, state) => state.when(
    //     live: () => const MBadge.live(),
    //     reconnecting: () => MBadge.reconnecting(context),
    //     streaming: () => const MBadge.live(),
    //     offAir: () => MBadge.offAir(context),
    //     failure: () => MBadge.offAir(context),
    //     loading: () => MBadge.offAir(context),
    //   ),
    // );
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return switch (state.status) {
          LiveBroadcastStatus.started => const MBadge.live(),
          LiveBroadcastStatus.joined => const MBadge.live(),
          LiveBroadcastStatus.offAir => MBadge.offAir(context),
          LiveBroadcastStatus.reconnecting => MBadge.reconnecting(context),
          _ => MBadge.offAir(context),
        };
      },
    );
  }
}
