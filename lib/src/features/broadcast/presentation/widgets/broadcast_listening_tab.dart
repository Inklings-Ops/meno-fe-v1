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
          padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
          height: 34.toScale,
          child: Row(
            children: [
              const _NumberOfParticipants(),
              const Spacer(),
              ExpandButton(
                onTap: () => context.showModal(
                  const BroadcastParticipantsModal(),
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: size.height * 0.9),
                ),
              ),
            ],
          ),
        ),
        $styles.spaces.verticalLarge,
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
          Icon(MIcons.hearing, size: 16.toScale),
          $styles.spaces.horizontalSmall,
          MText('$numberOfParticipants', style: $styles.text.captionMedium),
        ],
      ),
    );
  }
}
