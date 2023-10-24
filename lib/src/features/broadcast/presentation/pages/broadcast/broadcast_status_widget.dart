import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/broadcast/broadcast_notifier.dart';


class BroadcastStatusWidget extends ConsumerWidget {
  const BroadcastStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(broadcastStatusProvider)) {
      Status.live => const MBadge.live(),
      Status.offAir => MBadge.offAir(context),
      Status.reconnecting => MBadge.reconnecting(context),
    };
  }
}
