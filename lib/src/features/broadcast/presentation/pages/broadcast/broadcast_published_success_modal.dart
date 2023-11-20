import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'broadcast_timer.dart';

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
  final VoidCallback? onPressed;

  const _PublishingInProgressModal({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MText(
          "Publishing broadcast",
          style: MTextStyle.heading2Bold,
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        SizedBox.square(
          dimension: 96.r,
          child: Center(
            child: CircleAvatar(
              radius: 32.r,
              backgroundColor: colorScheme.onBackground,
            ),
          ),
        ),
        MCore.large.verticalSpace,
        const BroadcastTimer(textStyle: MTextStyle.heading2Bold),
        24.verticalSpace,
        32.verticalSpace,
        MCore.small.verticalSpace,
        const MText(
          "23 people tuned in!",
          style: MTextStyle.captionRegular,
          textAlign: TextAlign.center,
        ),
        80.verticalSpace,
        MSecondaryButton(label: "Cancel", onPressed: onPressed),
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
        Assets.images.onboarding1.image(height: 193.h),
        24.verticalSpace,
        const MText(
          "Broadcast Published!",
          style: MTextStyle.heading2Regular,
          textAlign: TextAlign.center,
        ),
        MCore.small.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
          child: const MText(
            "Now you and other people can go back and listen to this broadcast.",
            style: MTextStyle.captionRegular,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        40.verticalSpace,
        MPrimaryButton(label: "Go to Profile", onPressed: () {}),
      ],
    );
  }
}
