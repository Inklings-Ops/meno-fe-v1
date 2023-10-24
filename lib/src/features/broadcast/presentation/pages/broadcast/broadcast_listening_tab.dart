import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/services/socket_service/socket_service.dart';

import 'broadcast_participant_list.dart';
import 'broadcast_participants_modal.dart';

class BroadcastListeningTab extends HookConsumerWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);
    final numberOfParticipants = participants.length.toString();
    return Column(
      children: [
        24.verticalSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 34,
          child: Row(
            children: [
              Row(
                children: [
                  const Icon(MIcons.hearing, size: 16),
                  MSize.horizontalSpaceSmall,
                  MText(
                    numberOfParticipants,
                    style: MTextStyle.captionMedium,
                  ),
                ],
              ),
              const Spacer(),
              MPrimaryButton.icon(
                label: "Expand",
                icon: const Icon(MIcons.expand_01),

                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.9,
                  ),
                  builder: (context) => const BroadcastParticipantsModal(),
                ),
                // TODO: Handle button theme
              ),
            ],
          ),
        ),
        MSize.verticalSpaceLarge,
        const Expanded(child: BroadcastParticipantList()),
      ],
    );
  }
}
