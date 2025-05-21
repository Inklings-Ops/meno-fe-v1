import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastStartStopButton extends StatelessWidget {
  const BroadcastStartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    final broadcastBloc = context.watch<BroadcastBloc>();

    Future<void> stop() {
      return context.showEndBroadcastDialog().then((result) {
        if (result != true) return;
        final broadcastId = broadcastBloc.state.broadcast.id;
        broadcastBloc.add(BroadcastEndRequested(broadcastId));
      });
    }

    return MPrimaryButton(
      label: 'Stop broadcasting',
      onPressed: stop,
      loading: broadcastBloc.state.status.isLoading,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.errorContainer?.withValues(alpha: 0.3),
        foregroundColor: colors.error,
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
