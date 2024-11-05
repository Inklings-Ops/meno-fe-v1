import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastPublishedModal extends HookWidget {
  const BroadcastPublishedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isPublished = useState(false);

    Widget widget = _PublishingInProgressModal(
      onPressed: () => isPublished.value = true,
    );

    if (isPublished.value) {
      widget = const _SuccessModal();
    }

    return MModal(builder: (context) => widget);
  }
}

class _PublishingInProgressModal extends StatelessWidget {
  const _PublishingInProgressModal({this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MText(
          'Publishing broadcast',
          style: textTheme.heading2Bold,
          textAlign: TextAlign.center,
        ),
        Spaces.verticalXLarge,
        SizedBox.square(
          dimension: 96,
          child: Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor: colors.onBackground,
            ),
          ),
        ),
        Spaces.verticalLarge,
        BroadcastTimer(textStyle: textTheme.heading2Bold),
        Spaces.verticalXLarge,
        Spaces.verticalXXLarge, // Add avatars
        Spaces.verticalSmall,
        MText(
          '23 people tuned in!',
          style: textTheme.captionRegular,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 80),
        MSecondaryButton(label: 'Cancel', onPressed: onPressed),
      ],
    );
  }
}

class _SuccessModal extends StatelessWidget {
  const _SuccessModal();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Assets.images.onboarding1.image(height: 193),
        Spaces.verticalXLarge,
        MText(
          'Broadcast Published!',
          style: textTheme.heading2Regular,
          textAlign: TextAlign.center,
        ),
        Spaces.verticalSmall,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MText(
            'Now you and other people can go back and listen to this broadcast',
            style: textTheme.captionRegular,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 40),
        MPrimaryButton(label: 'Go to Profile', onPressed: () {}),
      ],
    );
  }
}
