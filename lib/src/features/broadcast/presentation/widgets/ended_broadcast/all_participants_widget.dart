import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class AllParticipantsWidget extends HookWidget {
  const AllParticipantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final bloc = context.read<ParticipantsBloc>();
    final broadcastId = context.read<BroadcastBloc>().state.broadcast.id;
    return BlocListener<SocketBloc, SocketState>(
      listener: (context, state) {
        state.whenOrNull(
          broadcastEnded: () => bloc.add(GetAllParticipants(broadcastId)),
        );
      },
      child: BlocBuilder<ParticipantsBloc, ParticipantsState>(
        builder: (context, state) => Column(
          children: [
            SizedBox(
              height: Insets.xxl,
              width: 92,
              child: Stack(
                alignment: Alignment.center,
                children: state.allParticipants
                    .map(
                      (e) => Positioned(
                        left: state.allParticipants.indexOf(e) * 30,
                        right: 0,
                        child: MAvatar(radius: 16, url: e.imageUrl),
                      ),
                    )
                    .toList(),
              ),
            ),
            Spaces.verticalSmall,
            MText(
              _getPluralText(state.numberOfAllParticipants),
              style: textTheme.captionRegular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getPluralText(int numberOfParticipants) {
    if (numberOfParticipants == 1) {
      return '$numberOfParticipants person tuned in!';
    } else {
      return '$numberOfParticipants people tuned in!';
    }
  }
}
