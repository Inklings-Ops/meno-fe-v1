import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class ParticipantList extends StatelessWidget {
  const ParticipantList({super.key, this.padding});
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ParticipantsBloc>();

    final myUserId = context.select(
      (SessionBloc bloc) => switch (bloc.state) {
        SessionAuthenticated(:final user) => user.id,
        _ => null,
      },
    );

    return BlocBuilder<ParticipantsBloc, ParticipantsState>(
      bloc: bloc,
      builder: (context, state) {
        final isLoading = state.loading;
        final participants = state.liveParticipants;
        if (isLoading) return const SizedBox();
        if (!isLoading && participants.isEmpty) return const SizedBox();
        return GridView.builder(
          shrinkWrap: true,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: Insets.sm,
            mainAxisSpacing: Insets.lg,
            childAspectRatio: 80 / 88,
          ),
          itemCount: participants.length,
          itemBuilder: (context, index) {
            final participant = participants[index]!;
            final id = participant.id;
            return ParticipantItem(
              key: ValueKey(participant.id.getOrCrash()),
              participant: participant,
              onTap: () {
                if (id == myUserId) return;
                context.showModal<void>(
                  BlocProvider(
                    create: (_) => OthersProfileCubit(
                      facade: di<IProfileFacade>(),
                      userId: id,
                    )..fetch(),
                    child: ParticipantInfoModal(participant: participant),
                  ),
                  isScrollControlled: true,
                  useRootNavigator: true,
                );
              },
            );
          },
        );
      },
    );
  }
}
