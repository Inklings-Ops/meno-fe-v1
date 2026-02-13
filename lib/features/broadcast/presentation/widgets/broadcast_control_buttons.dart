import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/presentation/widgets/broadcast_exit_alert_dialog.dart';
import 'package:meno/features/broadcast/presentation/widgets/broadcast_info_modal.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastControlButtons extends StatelessWidget {
  const BroadcastControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MicrophoneButton(key: Key('LiveBroadcastMicrophoneButton')),
          Spaces.horizontalSmall,
          _StartBroadcastingButton(key: Key('LiveBroadcastStartStopButton')),
          Spaces.horizontalSmall,
          _OptionsButton(key: Key('LiveBroadcastOptionsButton')),
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

class _StartBroadcastingButton extends WatchingWidget {
  const _StartBroadcastingButton({super.key});

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
        final result = await BroadcastExitAlertDialog.show(context);
        if (result ?? false) di<LiveSessionManager>().endSession.run();
      },
      loading: isEnding,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.errorContainer.withValues(alpha: 0.3),
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

class _OptionsButton extends WatchingWidget {
  const _OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final broadcast = di<LiveSessionManager>().broadcast;

    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () => BroadcastInfoModal.show(context, broadcast: broadcast),
    );
  }
}
