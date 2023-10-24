import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/pages/broadcast/participant_info_modal.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/pages/widgets/participant_item.dart';
import 'package:meno_fe_v1/src/services/socket_service/socket_service.dart';

class BroadcastParticipantList extends ConsumerWidget {
  const BroadcastParticipantList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: MCore.small,
        mainAxisSpacing: 24,
        childAspectRatio: 80 / 90,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) => ParticipantItem(
        isCohost: participants[index]?.isCohost == true,
        participant: participants[index],
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => ParticipantInfoModal(
            participant: participants[index]!,
          ),
        ),
      ),
    );
  }
}
