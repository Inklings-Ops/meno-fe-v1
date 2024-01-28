import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../application/live_participants/live_participants_cubit.dart';
import 'participant_info_modal.dart';
import 'participant_item.dart';

class BroadcastParticipantList extends StatelessWidget {
  const BroadcastParticipantList({super.key, required this.broadcastId});
  final String broadcastId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveParticipantsCubit, LiveParticipantsState>(
      bloc: context.read<LiveParticipantsCubit>()..fetch(broadcastId),
      buildWhen: (p, c) => p.participants != c.participants,
      builder: (context, state) {
        if (state.participants.isEmpty) return const SizedBox();
        
        if (state.loading) return const SizedBox();

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: MCore.small,
            mainAxisSpacing: 24.r,
            childAspectRatio: (80 / 90).r,
          ),
          itemCount: state.participants.length,
          itemBuilder: (context, index) => ParticipantItem(
            isCohost: state.participants[index]?.isCohost == true,
            participant: state.participants[index],
            onTap: () => context.showModal(
              ParticipantInfoModal(participant: state.participants[index]!),
              isScrollControlled: true,
            ),
          ),
        );
      },
    );
  }
}
