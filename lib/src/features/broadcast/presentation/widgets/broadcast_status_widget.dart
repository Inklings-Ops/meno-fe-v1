import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../services/meno/meno_bloc.dart';

class BroadcastStatusWidget extends StatelessWidget {
  final bool isStreaming;
  const BroadcastStatusWidget({super.key, this.isStreaming = false});

  @override
  Widget build(BuildContext context) {
    if (isStreaming) return const MBadge.live();

    return BlocConsumer<MenoBloc, MenoState>(
      buildWhen: (p, c) => p != c,
      listener: (context, state) {},
      builder: (context, state) => state.maybeWhen(
        live: () => const MBadge.live(),
        reconnecting: () => MBadge.reconnecting(context),
        streaming: () => const MBadge.live(),
        orElse: () => MBadge.offAir(context),
      ),
    );
  }
}
