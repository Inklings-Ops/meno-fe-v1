import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/presentation/widgets/participant_list.dart';
import 'package:meno/features/broadcast/presentation/widgets/participant_list_header_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastListeningTab extends StatelessWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('BroadcastListeningTab'),
      children: [
        MenoSpacer.v(Insets.xl),
        ParticipantListHeaderWidget(),
        MenoSpacer.v(Insets.lg),
        Expanded(child: ParticipantList()),
      ],
    );
  }
}
