import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class ParticipantsModal extends StatelessWidget {
  const ParticipantsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final numberOfLiveParticipants = context.select(
      (ParticipantsBloc bloc) => bloc.state.numberOfLiveParticipants,
    );
    return MModal(
      title: 'Listening ($numberOfLiveParticipants)',
      builder: (context) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MTextFormField(
            label: 'Search',
            prefixIcon: MIcons.search,
            showLabel: false,
            hint: 'Search',
          ),
          Spaces.verticalLarge,
          Expanded(child: ParticipantList(padding: EdgeInsets.zero)),
        ],
      ),
    );
  }
}
