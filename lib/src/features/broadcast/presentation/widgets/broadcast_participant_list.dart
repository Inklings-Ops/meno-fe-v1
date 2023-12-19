import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../services/socket/socket_service.dart';
import 'participant_info_modal.dart';
import 'participant_item.dart';

class BroadcastParticipantList extends HookConsumerWidget {
  const BroadcastParticipantList({super.key, required this.broadcastId});
  final String broadcastId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final participants = ref.watch(liveParticipantsProvider);

    final list = useState<List<Participant?>>([]);
    final participants1 = ref.watch(getParticipantsProvider(broadcastId));

//     ref.listen(socketServiceProvider, (previous, next) {
//       if(previous?.numberOfLiveBroadcasts !=next.numberOfLiveBroadcasts) {
// list.value = ref.
//       }
//     })

    return participants1.when(
      data: (data) => GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16).r,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: MCore.small,
          mainAxisSpacing: 24.r,
          childAspectRatio: (80 / 90).r,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) => ParticipantItem(
          isCohost: data[index]?.isCohost == true,
          participant: data[index],
          onTap: () => context.showModal(
            ParticipantInfoModal(participant: data[index]!),
            isScrollControlled: true,
          ),
        ),
      ),
      error: (error, stackTrace) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}
