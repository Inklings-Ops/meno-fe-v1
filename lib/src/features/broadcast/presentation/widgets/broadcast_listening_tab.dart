import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../application/live_participants/live_participants_cubit.dart';
import '../widgets/broadcast_participant_list.dart';
import '../widgets/broadcast_participants_modal.dart';

class BroadcastListeningTab extends StatelessWidget {
  const BroadcastListeningTab({super.key, required this.broadcastId});
  final String broadcastId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        24.verticalSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          height: 34.h,
          child: Row(
            children: [
              const _NumberOfParticipants(),
              const Spacer(),
              ExpandButton(
                onTap: () => context.showModal(
                  BroadcastParticipantsModal(broadcastId: broadcastId),
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: 0.9.sh),
                ),
              ),
            ],
          ),
        ),
        MCore.large.verticalSpace,
        Expanded(child: BroadcastParticipantList(broadcastId: broadcastId)),
      ],
    );
  }
}

class _NumberOfParticipants extends StatelessWidget {
  const _NumberOfParticipants();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LiveParticipantsCubit, LiveParticipantsState, int>(
      selector: (state) => state.participants.length,
      builder: (context, length) => Row(
        children: [
          Icon(MIcons.hearing, size: 16.r),
          MCore.small.horizontalSpace,
          MText('$length', style: MTextStyle.captionMedium),
        ],
      ),
    );
  }
}
