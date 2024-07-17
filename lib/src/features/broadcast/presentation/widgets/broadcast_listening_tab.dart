import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';


class BroadcastListeningTab extends StatelessWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          height: 34.h,
          child: Row(
            children: [
              const _NumberOfParticipants(),
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

class _NumberOfParticipants extends StatelessWidget {
  const _NumberOfParticipants();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LiveParticipantsBloc, LiveParticipantsState, int>(
      selector: (state) => state.numberOfParticipants,
      builder: (context, numberOfParticipants) => Row(
        children: [
          Icon(MIcons.hearing, size: 16.r),
          MCore.small.horizontalSpace,
          MText('$numberOfParticipants', style: MTextStyle.captionMedium),
        ],
      ),
    );
  }
}
