import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../services/meno/meno_bloc.dart';

class BroadcastStatusWidget extends StatelessWidget {
  final bool isStreaming;
  const BroadcastStatusWidget({super.key, this.isStreaming = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenoBloc, MenoState>(
      bloc: context.read<MenoBloc>(),
      buildWhen: (p, c) => p != c,
      builder: (context, state) => state.maybeWhen(
        live: (_) => const MBadge.live(),
        reconnecting: (_) => MBadge.reconnecting(context),
        streaming: (_) => const MBadge.live(),
        orElse: () => MBadge.offAir(context),
      ),
    );
  }
}
