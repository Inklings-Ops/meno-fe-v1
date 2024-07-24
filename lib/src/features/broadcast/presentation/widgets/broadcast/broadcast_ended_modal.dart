import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastEndedModal extends HookWidget {
  const BroadcastEndedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = useState(false);
    return PopScope(
      canPop: canPop.value,
      onPopInvoked: (_) {
        context.read<BroadcastBloc>().dispose();
        context.read<TimerCubit>().dispose();
        context.go(Routes.home);
        canPop.value = true;
      },
      child: MModal(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).radius,
              child: MText(
                'Your live broadcast is complete! Great job.',
                style: $styles.text.heading2Bold,
                textAlign: TextAlign.center,
              ),
            ),
            24.vSpace,
            const BroadcastArtworkWidget(),
            $styles.spaces.verticalLarge,
            BroadcastTimer(
              showTimeAgo: false,
              textStyle: $styles.text.heading2Bold,
            ),
            24.vSpace,
            // TODO: implement avatars of listeners
            $styles.spaces.verticalXXLarge,
            $styles.spaces.verticalSmall,
            BlocSelector<LiveParticipantsBloc, LiveParticipantsState, int>(
              selector: (state) => state.participants.length,
              builder: (context, numberOfParticipants) => MText(
                '$numberOfParticipants people tuned in!',
                style: $styles.text.captionRegular,
                textAlign: TextAlign.center,
              ),
            ),
            40.vSpace,
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            $styles.spaces.verticalLarge,
            MSecondaryButton(
              label: 'Go to Profile',
              onPressed: () => context.go(Routes.profile),
            ),
          ],
        ),
      ),
    );
  }
}
