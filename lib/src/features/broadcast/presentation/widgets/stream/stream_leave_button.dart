import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamLeaveButton extends StatelessWidget {
  const StreamLeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcastBloc = context.watch<BroadcastBloc>();
    final broadcastId = broadcastBloc.state.broadcast.id;

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return MPrimaryButton.icon(
      label: 'Leave Broadcast',
      onPressed: () {
        context.showLeaveBroadcastDialog().then((value) {
          if (value != true) return;
          broadcastBloc.add(BroadcastLeaveRequested(broadcastId));
        });
      },
      icon: const Icon(MIcons.log_out),
      style: ElevatedButton.styleFrom(
        foregroundColor: colors.error,
        iconColor: colors.error,
        backgroundColor: colors.errorContainer?.withValues(alpha: 0.3),
        fixedSize: const Size(159, 40),
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.sm,
        ),
        textStyle: textTheme.captionMedium,
        shape: const RoundedRectangleBorder(borderRadius: Corners.circle),
      ),
    );
  }
}
