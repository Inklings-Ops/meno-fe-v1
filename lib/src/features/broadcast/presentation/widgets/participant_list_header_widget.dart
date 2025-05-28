import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class ParticipantListHeaderWidget extends StatelessWidget {
  const ParticipantListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      height: 34,
      child: Row(
        spacing: Insets.sm,
        children: [
          const Expanded(child: _ParticipantCountWidget()),
          ExpandButton(
            onTap: () => context.showModal<void>(
              const ParticipantsModal(),
              isScrollControlled: true,
              constraints: BoxConstraints(maxHeight: size.height * 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantCountWidget extends StatelessWidget {
  const _ParticipantCountWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Row(
      children: [
        Icon(MIcons.hearing, size: 18, color: colors.onDisabled),
        const MenoSpacer.h(Insets.xs),
        BlocSelector<ParticipantsBloc, ParticipantsState, int>(
          selector: (state) => state.numberOfLiveParticipants,
          builder: (context, numberOfLiveParticipants) => MenoText.caption(
            numberOfLiveParticipants.toString(),
            color: colors.onDisabled,
          ),
        ),
      ],
    );
  }
}
