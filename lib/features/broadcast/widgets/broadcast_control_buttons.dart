import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastControlButtons extends WatchingWidget {
  const BroadcastControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isHost = watchValue((LiveSessionManager m) => m.isHost);
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: .center,
        children: [
          if (isHost) ...[
            const _MicrophoneButton(key: Key('BroadcastMicrophoneButton')),
            Spaces.horizontalSmall,
            const _StopBroadcastingButton(key: Key('BroadcastStopButton')),
          ] else ...[
            const _LeaveBroadcastButton(key: Key('LeaveBroadcastButton')),
          ],
          Spaces.horizontalSmall,
          const BroadcastOptionsButton(),
        ],
      ),
    );
  }
}

class _MicrophoneButton extends WatchingWidget {
  const _MicrophoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    final enabled = watchValue((LiveSessionManager m) => m.isMicrophoneEnabled);
    return MMicrophoneButton(
      isMicrophoneEnabled: enabled,
      onTap: () => di<LiveSessionManager>().toggleMicrophone.run(!enabled),
    );
  }
}

class _StopBroadcastingButton extends WatchingWidget {
  const _StopBroadcastingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final isEnding = watchValue(
      (LiveSessionManager m) => m.endSession.isRunning,
    );

    return MPrimaryButton(
      label: 'Stop broadcasting',
      onPressed: () async {
        final result = await BroadcastExitAlertDialog.show(context, true);
        if (result ?? false) di<LiveSessionManager>().endSession.run();
      },
      loading: isEnding,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.errorContainer.withValues(alpha: 0.3),
        foregroundColor: colors.error,
        fixedSize: const Size(159, 40),
        padding: const .symmetric(horizontal: Insets.lg, vertical: Insets.sm),
        textStyle: textTheme.captionMedium,
        shape: const RoundedRectangleBorder(borderRadius: Corners.circle),
      ),
    );
  }
}

class _LeaveBroadcastButton extends WatchingWidget {
  const _LeaveBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final isEnding = watchValue(
      (LiveSessionManager m) => m.endSession.isRunning,
    );

    return MPrimaryButton.icon(
      label: 'Leave broadcast',
      icon: const Icon(MIcons.log_out),
      onPressed: () async {
        final result = await BroadcastExitAlertDialog.show(context, true);
        if (result ?? false) di<LiveSessionManager>().endSession.run();
      },
      loading: isEnding,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.errorContainer.withValues(alpha: 0.3),
        foregroundColor: colors.error,
        iconColor: colors.errorContainer,
        fixedSize: const Size(159, 40),
        padding: const .symmetric(horizontal: Insets.lg, vertical: Insets.sm),
        textStyle: textTheme.captionMedium,
        shape: const RoundedRectangleBorder(borderRadius: Corners.circle),
      ),
    );
  }
}
