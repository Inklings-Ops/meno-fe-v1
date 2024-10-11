import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastEndedModal extends HookWidget {
  const BroadcastEndedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final canPop = useState(false);
    return PopScope(
      canPop: canPop.value,
      onPopInvoked: (_) {
        context.read<TimerCubit>().dispose();
        router.go(Routes.home);
        canPop.value = true;
      },
      child: MModal(
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
            // TODO: implement avatars of listeners
            Spaces.verticalXXLarge,
            Spaces.verticalSmall,
            BlocSelector<LiveParticipantsBloc, LiveParticipantsState, int>(
              selector: (state) => state.participants.length,
              builder: (context, numberOfParticipants) => MText(
                '$numberOfParticipants people tuned in!',
                style: textTheme.captionRegular,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            Spaces.verticalLarge,
            MSecondaryButton(
              label: 'Go to Profile',
              onPressed: () => router.go(Routes.profile),
            ),
          ],
        ),
      ),
    );
  }
}
