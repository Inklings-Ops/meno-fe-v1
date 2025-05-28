import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTimerWidget extends StatelessWidget {
  const BroadcastTimerWidget({
    super.key,
    this.showTimeAgo = true,
    this.textStyle,
  });

  final bool showTimeAgo;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return BlocBuilder<TimerCubit, TimerState>(
      bloc: context.watch<TimerCubit>(),
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        final elapsed = state.elapsed;
        final isRunning = state.isRunning;

        final hoursStr = elapsed.hoursFormatted;
        final minutesStr = elapsed.minutesFormatted;
        final secondsStr = elapsed.secondsFormatted;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MText(
              '$hoursStr:$minutesStr:$secondsStr',
              style: textStyle ?? textTheme.captionRegular,
              color: colors.onDisabledContainer,
            ),
            if (isRunning && showTimeAgo) ...[
              Spaces.horizontalSmall,
              const MDot(),
              Spaces.horizontalSmall,
              MText(
                elapsed.timeAgo,
                style: textTheme.captionRegular,
                color: colors.onDisabledContainer,
              ),
            ],
          ],
        );
      },
    );
  }
}
