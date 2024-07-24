import 'package:meno_fe_v1/meno.dart';
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
          $styles.spaces.verticalLarge,
          const Expanded(
            child: BroadcastParticipantList(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }
}
