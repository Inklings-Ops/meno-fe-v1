import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/timer/timer_notifier.dart';

class BroadcastTimer extends ConsumerWidget {
  final bool showTimeAgo;
  final MTextStyle? textStyle;

  const BroadcastTimer({super.key, this.showTimeAgo = true, this.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final elapsedTime = ref.watch(timerNotifierProvider.select((value) {
      return "${value.hours}:${value.minutes}:${value.seconds}";
    }));

    final timeAgo = ref.watch(timerNotifierProvider.select((v) => v.timeAgo));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(
          elapsedTime,
          style: textStyle ?? MTextStyle.captionRegular,
          color: colorScheme.onDisabledContainer,
        ),
        if (timeAgo != null && showTimeAgo) ...[
          MCore.small.horizontalSpace,
          const MDot(),
          MCore.small.horizontalSpace,
          MText(
            timeAgo,
            style: MTextStyle.captionRegular,
            color: colorScheme.onDisabledContainer,
          ),
        ],
      ],
    );
  }
}
