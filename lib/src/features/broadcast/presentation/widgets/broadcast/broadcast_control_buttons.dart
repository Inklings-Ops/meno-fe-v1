import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

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

class _MicrophoneButton extends StatelessWidget {
  const _MicrophoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      buildWhen: (p, c) => p.isMicrophoneEnabled != c.isMicrophoneEnabled,
      builder: (context, state) => MMicrophoneButton(
        isMicrophoneEnabled: state.isMicrophoneEnabled,
        onTap: () {
          final bloc = context.read<BroadcastBloc>();
          if (state.isMicrophoneEnabled) {
            bloc.add(const BroadcastMuteMicRequested());
          } else {
            bloc.add(const BroadcastUnMuteMicRequested());
          }
        },
      ),
    );
  }
}

class _StartBroadcastingButton extends StatelessWidget {
  const _StartBroadcastingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

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

class _OptionsButton extends StatelessWidget {
  const _OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () =>
          rootNavigatorKey.currentContext?.push(Routes.broadcastInfoModal),
    );
  }
}
