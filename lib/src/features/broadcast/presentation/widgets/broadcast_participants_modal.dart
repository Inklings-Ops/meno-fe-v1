import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/widgets/broadcast_participant_list.dart';

import '../../../../services/socket/socket_service.dart';

class BroadcastParticipantsModal extends ConsumerWidget {
  const BroadcastParticipantsModal({super.key, required this.broadcastId});
  final String broadcastId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);
    final numberOfParticipants = participants.length;

    return MModal(
      title: 'Listening (${numberOfParticipants.toString()})',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MTextFormField(
            label: 'Search',
            prefixIcon: MIcons.search,
            showLabel: false,
            hint: 'Search',
          ),
          MCore.large.verticalSpace,
          Expanded(
            child: BroadcastParticipantList(broadcastId: broadcastId),
          ),
        ],
      ),
    );
  }
}
