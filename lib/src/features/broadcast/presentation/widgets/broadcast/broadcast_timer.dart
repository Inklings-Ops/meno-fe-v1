import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTimer extends StatelessWidget {
  const BroadcastTimer({super.key, this.showTimeAgo = true, this.textStyle});
  final bool showTimeAgo;
  final MTextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return BlocBuilder<TimerCubit, TimerState>(
      bloc: context.watch<TimerCubit>(),
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        final elapsedTime = '${state.hours}:${state.minutes}:${state.seconds}';
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MText(
              elapsedTime,
              style: textStyle ?? MTextStyle.captionRegular,
              color: colors.onDisabledContainer,
            ),
            if (state.timeAgo != null && showTimeAgo) ...[
              MCore.small.horizontalSpace,
              const MDot(),
              MCore.small.horizontalSpace,
              MText(
                state.timeAgo!,
                style: MTextStyle.captionRegular,
                color: colors.onDisabledContainer,
              ),
            ],
          ],
        );
      },
    );
  }
}
