import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/pages/broadcast/broadcast_participant_list.dart';

import '../../../../../services/socket_service/socket_service.dart';

class BroadcastParticipantsModal extends ConsumerWidget {
  const BroadcastParticipantsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);
    final numberOfParticipants = participants.length;

    return MModal(
      title: "Listening (${numberOfParticipants.toString()})",
      builder: (context) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MTextFormField(
            label: "Search",
            prefixIcon: MIcons.search,
            showLabel: false,
            hint: "Search",
          ),
          MSize.verticalSpaceLarge,
          Expanded(
            child: BroadcastParticipantList(),
          ),
        ],
      ),
    );
  }
}
