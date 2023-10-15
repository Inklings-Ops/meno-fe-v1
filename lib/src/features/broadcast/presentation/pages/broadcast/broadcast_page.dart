import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

@RoutePage()
class BroadcastPage extends StatefulHookConsumerWidget {
  const BroadcastPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage> {
  @override
  Widget build(BuildContext context) {
    return const MScaffold();
  }
}
