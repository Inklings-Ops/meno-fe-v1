import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/participants_manager.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ParticipantListHeaderWidget extends StatelessWidget {
  const ParticipantListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      height: 34,
      child: Row(
        spacing: Insets.sm,
        children: [
          const Expanded(child: _ParticipantCountWidget()),
          ExpandButton(onTap: () => ParticipantsModal.show(context)),
        ],
      ),
    );
  }
}

class _ParticipantCountWidget extends WatchingWidget {
  const _ParticipantCountWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final totalCount = watchValue((ParticipantsManager m) => m.totalCount);
    return Row(
      children: [
        Icon(MIcons.hearing, size: 18, color: colors.onDisabled),
        const MenoSpacer.h(Insets.xs),
        MenoText.caption(totalCount.toString(), color: colors.onDisabled),
      ],
    );
  }
}
