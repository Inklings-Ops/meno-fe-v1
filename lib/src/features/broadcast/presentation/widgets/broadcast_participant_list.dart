import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastParticipantList extends StatelessWidget {
  const BroadcastParticipantList({super.key, this.padding});
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveParticipantsBloc, LiveParticipantsState>(
      buildWhen: (p, c) => p.liveParticipants != c.liveParticipants,
      builder: (context, state) {
        final isLoading = state.loading;
        final participants = state.liveParticipants;
        if (isLoading) return const SizedBox();
        if (!isLoading && participants.isEmpty) return const SizedBox();
        return GridView.builder(
          shrinkWrap: true,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: Insets.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: Insets.sm,
            mainAxisSpacing: Insets.lg,
            childAspectRatio: 80 / 88,
          ),
          itemCount: participants.length,
          itemBuilder: (context, index) {
            final participant = participants[index];
            return ParticipantItem(
              key: ValueKey(participant.id),
              participant: participant,
              onTap: () => context.showModal<void>(
                ParticipantInfoModal(participant: participant),
                isScrollControlled: true,
                useRootNavigator: true,
              ),
            );
          },
        );
      },
    );
  }
}
