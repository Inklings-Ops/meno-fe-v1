import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'broadcast_participant_list.dart';
 

class BroadcastParticipantsModal extends StatelessWidget {
  const BroadcastParticipantsModal({super.key, required this.broadcastId});
  final String broadcastId;

  @override
  Widget build(BuildContext context) {

    return MModal(
      title: 'Listening (${0.toString()})',
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
