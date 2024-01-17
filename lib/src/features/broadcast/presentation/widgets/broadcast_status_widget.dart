import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/core/broadcast/meno_event_provider.dart';

import '../../domain/domain.dart';

class BroadcastStatusWidget extends ConsumerWidget {
  final bool isBroadcasting;
  const BroadcastStatusWidget({super.key, this.isBroadcasting = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isBroadcasting) {
      return const MBadge.live();
    }

    return switch (ref.watch(eventProvider).status) {
      Status.live => const MBadge.live(),
      Status.offAir => MBadge.offAir(context),
      Status.reconnecting => MBadge.reconnecting(context),
      _ => const SizedBox(),
    };
  }
}
