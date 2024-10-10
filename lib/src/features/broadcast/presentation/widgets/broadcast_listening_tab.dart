import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastListeningTab extends StatelessWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
          height: 34,
          child: Row(
            children: [
              const _NumberOfParticipants(),
              const Spacer(),
              ExpandButton(
                onTap: () => context.showModal<void>(
                  const BroadcastParticipantsModal(),
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: size.height * 0.9),
                ),
              ),
            ],
          ),
        ),
        Spaces.verticalLarge,
        const Expanded(child: BroadcastParticipantList()),
      ],
    );
  }
}

class _NumberOfParticipants extends StatelessWidget {
  const _NumberOfParticipants();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return BlocSelector<LiveParticipantsBloc, LiveParticipantsState, int>(
      selector: (state) => state.numberOfParticipants,
      builder: (context, numberOfParticipants) => Row(
        children: [
          const Icon(MIcons.hearing, size: 16),
          Spaces.horizontalSmall,
          MText('$numberOfParticipants', style: textTheme.captionMedium),
        ],
      ),
    );
  }
}
