import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastStatusWidget extends WatchingWidget {
  const BroadcastStatusWidget({required this.status, super.key});

  final LiveStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      LiveStatus.live => const MBadge.live(),
      LiveStatus.offAir => MBadge.offAir(context),
      LiveStatus.reconnecting => MBadge.reconnecting(context),
      _ => MBadge.offAir(context),
    };
  }
}
