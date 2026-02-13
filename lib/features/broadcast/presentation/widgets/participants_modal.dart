import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ParticipantsModal extends StatelessWidget {
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
    // final numberOfLiveParticipants = context.select(
    //   (ParticipantsBloc bloc) => bloc.state.numberOfLiveParticipants,
    // );
    return MModal(
      // title: 'Listening ($numberOfLiveParticipants)',
      title: 'Listening (2)',
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
          // Expanded(child: ParticipantList(padding: EdgeInsets.zero)),
        ],
      ),
    );
  }
}
