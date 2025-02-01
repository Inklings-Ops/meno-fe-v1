import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class BroadcastParticipantList extends StatelessWidget {
  const BroadcastParticipantList({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ParticipantsBloc>();

    final currentUser = context.select(
      (SessionBloc bloc) => bloc.state.maybeWhen(
        orElse: User.empty,
        authenticated: (user, token) => user,
      ),
    );

    return BlocListener<SocketBloc, SocketState>(
      listener: (context, state) {
        state.whenOrNull(
          newBroadcastListener: (participant) {
            bloc.add(ParticipantJoined(participant));
          },
          broadcastListenerLeft: (participant) {
            bloc.add(ParticipantLeft(participant));
          },
        );
      },
      child: BlocBuilder<ParticipantsBloc, ParticipantsState>(
        bloc: bloc,
        buildWhen: (p, c) => p.liveParticipants != c.liveParticipants,
        builder: (context, state) {
          final isLoading = state.loading;
          final participants = state.liveParticipants;
          if (isLoading) return const SizedBox();
          if (!isLoading && participants.isEmpty) return const SizedBox();
          return GridView.builder(
            shrinkWrap: true,
            padding:
                padding ?? const EdgeInsets.symmetric(horizontal: Insets.lg),
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
                onTap: () {
                  if (participant.id == currentUser.id.getOr()) return;
                  context.showModal<void>(
                    ParticipantInfoModal(participant: participant),
                    isScrollControlled: true,
                    useRootNavigator: true,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
