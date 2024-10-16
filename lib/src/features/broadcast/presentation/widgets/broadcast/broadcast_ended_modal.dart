import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/live_kit/live_kit.dart';



class BroadcastEndedModal extends HookWidget {
  const BroadcastEndedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    void cleanUp() {
      context.read<TimerCubit>().dispose();
      context.read<LiveKitService>().dispose();
      context.read<BroadcastBloc>().dispose();
      context.read<LiveParticipantsBloc>().close();
      context.read<ChatBloc>().close();
    }

    return PopScope(
      onPopInvoked: (_) {
        router.go(Routes.home);
        cleanUp();
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
            const TotalParticipantsWidget(),
            const SizedBox(height: 40),
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            Spaces.verticalLarge,
            MSecondaryButton(
              label: 'Go to Profile',
              onPressed: () {
                router.go(Routes.myProfile);
                cleanUp();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TotalParticipantsWidget extends HookWidget {
  const TotalParticipantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    return BlocBuilder<LiveParticipantsBloc, LiveParticipantsState>(
      builder: (context, state) => Column(
        children: [
          SizedBox(
            height: Insets.xxl,
            width: 92,
            child: Stack(
              alignment: Alignment.center,
              children: state.totalParticipants
                  .map(
                    (e) => Positioned(
                      left: state.totalParticipants.indexOf(e) * 30,
                      right: 0,
                      child: MAvatar(radius: 16, url: e.imageUrl),
                    ),
                  )
                  .toList(),
            ),
          ),
          Spaces.verticalSmall,
          MText(
            _getPluralText(state.numberOfTotalParticipants),
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
