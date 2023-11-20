import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../services/socket/socket_service.dart';
import 'participant_info_modal.dart';
import 'participant_item.dart';

class BroadcastParticipantList extends ConsumerWidget {
  const BroadcastParticipantList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16).r,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: MCore.small,
        mainAxisSpacing: 24.r,
        childAspectRatio: (80 / 90).r,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) => ParticipantItem(
        isCohost: participants[index]?.isCohost == true,
        participant: participants[index],
        onTap: () => context.showModal(
          ParticipantInfoModal(participant: participants[index]!),
          isScrollControlled: true,
        ),
      ),
    );
  }
}
