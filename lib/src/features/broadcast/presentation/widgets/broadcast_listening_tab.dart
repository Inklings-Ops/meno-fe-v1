import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../services/socket/socket_service.dart';
import '../widgets/broadcast_participant_list.dart';
import '../widgets/broadcast_participants_modal.dart';

class BroadcastListeningTab extends ConsumerWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);
    final numberOfParticipants = participants.length.toString();

    return Column(
      children: [
        24.verticalSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          height: 34.h,
          child: Row(
            children: [
              Row(
                children: [
                  Icon(MIcons.hearing, size: 16.r),
                  MCore.small.horizontalSpace,
                  MText(numberOfParticipants, style: MTextStyle.captionMedium),
                ],
              ),
              const Spacer(),
              ExpandButton(
                onTap: () => context.showModal(
                  const BroadcastParticipantsModal(),
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: 0.9.sh),
                ),
              ),
            ],
          ),
        ),
        MCore.large.verticalSpace,
        const Expanded(child: BroadcastParticipantList()),
      ],
    );
  }
}
