import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamControlButtons extends StatelessWidget {
  const StreamControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Row(
        spacing: Insets.sm,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LeaveButton(key: Key('LiveStreamLeaveButton')),
          _OptionsButton(key: Key('LiveStreamOptionsButton')),
        ],
      ),
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcastBloc = context.watch<BroadcastBloc>();
    final broadcastId = broadcastBloc.state.broadcast.id;

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
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
        backgroundColor: colors.errorContainer.withValues(alpha: 0.3),
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

class _OptionsButton extends StatelessWidget {
  const _OptionsButton({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final broadcast = context.select((BroadcastBloc b) => b.state.broadcast);
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () => context.showModal<void>(
        BroadcastInfoModal(broadcast: broadcast, isStreaming: true),
        isScrollControlled: true,
      ),
    );
  }
}
