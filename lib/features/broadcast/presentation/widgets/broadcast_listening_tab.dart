import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/participants_manager.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastListeningTab extends WatchingWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    final list = watchValue((ParticipantsManager m) => m.displayedParticipants);
    final hasMore = watchValue((ParticipantsManager m) => m.hasMore);
    final isLoading = watchValue((ParticipantsManager m) => m.isLoading);

    return Column(
      key: const Key('BroadcastListeningTab'),
      children: [
        Spaces.verticalXLarge,
        const ParticipantListHeaderWidget(),

        Spaces.verticalLarge,
        Expanded(
          child: ParticipantsGrid(participants: list, isLoading: isLoading),
        ),

        if (hasMore) ...[
          Spaces.verticalLarge,
          MSecondaryButton(
            label: 'Load More',
            onPressed: () => di<ParticipantsManager>().loadMore(),
          ),
        ],
      ],
    );
  }
}
