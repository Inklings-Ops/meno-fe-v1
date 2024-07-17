import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastParticipantsModal extends StatelessWidget {
  const BroadcastParticipantsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final numberOfParticipants = context.select(
      (LiveParticipantsBloc bloc) => bloc.state.numberOfParticipants,
    );
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
          const Expanded(
            child: BroadcastParticipantList(
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
