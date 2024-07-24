import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTimer extends StatelessWidget {
  const BroadcastTimer({super.key, this.showTimeAgo = true, this.textStyle});
  final bool showTimeAgo;
  final TextStyle? textStyle;

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
              style: textStyle ?? $styles.text.captionRegular,
              color: colors.onDisabledContainer,
            ),
            if (state.timeAgo != null && showTimeAgo) ...[
              $styles.spaces.horizontalSmall,
              const MDot(),
              $styles.spaces.horizontalSmall,
              MText(
                state.timeAgo!,
                style: $styles.text.captionRegular,
                color: colors.onDisabledContainer,
              ),
            ],
          ],
        );
      },
    );
  }
}
