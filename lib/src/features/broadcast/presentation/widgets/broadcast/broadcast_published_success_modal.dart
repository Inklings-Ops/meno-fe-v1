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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MText(
          'Publishing broadcast',
          style: $styles.text.heading2Bold,
          textAlign: TextAlign.center,
        ),
        24.vSpace,
        SizedBox.square(
          dimension: 96.toScale,
          child: Center(
            child: CircleAvatar(
              radius: 32.toScale,
              backgroundColor: colors.onBackground,
            ),
          ),
        ),
        $styles.spaces.verticalLarge,
        BroadcastTimer(textStyle: $styles.text.heading2Bold),
        24.vSpace,
        32.vSpace,
        $styles.spaces.verticalSmall,
        MText(
          '23 people tuned in!',
          style: $styles.text.captionRegular,
          textAlign: TextAlign.center,
        ),
        80.vSpace,
        MSecondaryButton(label: 'Cancel', onPressed: onPressed),
      ],
    );
  }
}

class _SuccessModal extends StatelessWidget {
  const _SuccessModal();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Assets.images.onboarding1.image(height: 193.toScale),
        24.vSpace,
        MText(
          'Broadcast Published!',
          style: $styles.text.heading2Regular,
          textAlign: TextAlign.center,
        ),
        $styles.spaces.verticalSmall,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
          child: MText(
            'Now you and other people can go back and listen to this broadcast.',
            style: $styles.text.captionRegular,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        40.vSpace,
        MPrimaryButton(label: 'Go to Profile', onPressed: () {}),
      ],
    );
  }
}
