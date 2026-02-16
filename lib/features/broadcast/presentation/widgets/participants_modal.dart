import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/participants_manager.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ParticipantsModal extends WatchingWidget {
  const ParticipantsModal({super.key});

  static Future<dynamic> show(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => const ParticipantsModal(),
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.9),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = di<ParticipantsManager>();
    final list = watchValue((ParticipantsManager m) => m.displayedParticipants);
    final totalCount = watchValue((ParticipantsManager m) => m.totalCount);
    final isSearching = watchValue((ParticipantsManager m) => m.isSearching);
    final isLoading = watchValue((ParticipantsManager m) => m.isLoading);
    final query = watchValue((ParticipantsManager m) => m.searchQuery);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        manager.clearSearch.run();
      },
      child: MModal(
        title: 'Listening ($totalCount)',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MTextFormField(
              label: 'Search',
              prefixIcon: MIcons.search,
              showLabel: false,
              hint: 'Search',
              initialValue: query,
              onChanged: manager.updateSearch.run,
            ),
            Spaces.verticalLarge,
            Expanded(
              child: ParticipantsGrid(
                participants: list,
                isSearching: isSearching,
                isLoading: isLoading,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
