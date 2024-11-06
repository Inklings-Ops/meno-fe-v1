import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/live_kit/live_kit.dart';

class BroadcastEndedModal extends StatelessWidget {
  const BroadcastEndedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        router.go(Routes.home);
        cleanUp(context);
      },
      child: MModal(
        key: const ValueKey('BroadcastEndedModal'),
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MText(
                'Your live broadcast is complete! Great job.',
                style: textTheme.heading2Bold,
                textAlign: TextAlign.center,
              ),
            ),
            Spaces.verticalXLarge,
            const BroadcastArtworkWidget(),
            Spaces.verticalLarge,
            BroadcastTimer(
              showTimeAgo: false,
              textStyle: textTheme.heading2Bold,
            ),
            Spaces.verticalXLarge,
            const AllParticipantsWidget(),
            const SizedBox(height: 40),
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            Spaces.verticalLarge,
            MSecondaryButton(
              label: 'Go to Profile',
              onPressed: () {
                router.go(Routes.myProfile);
                cleanUp(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void cleanUp(BuildContext context) {
    context.read<TimerCubit>().dispose();
    di<LiveKitService>().dispose();
    context.read<ParticipantsBloc>().add(const ParticipantsReset());
    context.read<ChatBloc>().add(const ChatReset());
    context.read<BroadcastBloc>().add(const BroadcastReset());
  }
}

/// Displays all the [BroadcastParticipant]s that have joined through out the
/// lifecycle of the live [Broadcast]
class AllParticipantsWidget extends HookWidget {
  const AllParticipantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    return BlocBuilder<ParticipantsBloc, ParticipantsState>(
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
