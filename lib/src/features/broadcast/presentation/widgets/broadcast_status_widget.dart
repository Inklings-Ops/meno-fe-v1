import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastStatusWidget extends StatelessWidget {
  final bool isStreaming;
  const BroadcastStatusWidget({super.key, this.isStreaming = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenoBloc, MenoState>(
      bloc: context.watch<MenoBloc>(),
      builder: (context, state) => state.when(
        live: () => const MBadge.live(),
        reconnecting: () => MBadge.reconnecting(context),
        streaming: () => const MBadge.live(),
        offAir: () => MBadge.offAir(context),
        endedBroadcast: (_) => MBadge.offAir(context),
        leaveBroadcast: () => MBadge.offAir(context),
        leftBroadcast: (_) => const MBadge.live(),
      ),
    );
  }
}
