import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MicrophoneButton(),
          Spaces.horizontalSmall,
          _StartStopButton(),
          Spaces.horizontalSmall,
          _MoreOptionsButton(),
        ],
      ),
    );
  }
}

class _MicrophoneButton extends StatelessWidget {
  const _MicrophoneButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastBloc>();
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      bloc: bloc,
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => state.status.maybeWhen(
        orElse: () => const MMicrophoneButton(isDisabled: true),
        started: (isMicrophoneEnabled, _) => MMicrophoneButton(
          isMicrophoneEnabled: isMicrophoneEnabled,
          onTap: () => bloc.add(const BroadcastMuteToggled()),
        ),
      ),
    );
  }
}

class _StartStopButton extends StatelessWidget {
  const _StartStopButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.watch<BroadcastBloc>();
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      bloc: bloc,
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => state.status.maybeWhen(
        loading: () => const _Button(label: 'Start', loading: true),
        broadcastEnded: () => const _Button(label: 'Stop broadcasting'),
        orElse: () => _Button(
          label: 'Start broadcasting',
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          onTap: () => bloc.add(const BroadcastStartPressed()),
        ),
        started: (microphoneEnabled, reconnected) => _Button(
          label: 'Stop broadcasting',
          backgroundColor: colors.errorContainer?.withOpacity(0.3),
          foregroundColor: colors.error,
          onTap: () => context.showEndBroadcastDialog().then((value) {
            if (value != true) return;
            return bloc.add(BroadcastEndPressed(state.broadcast.id));
          }),
        ),
      ),
    );
  }
}

class _MoreOptionsButton extends StatelessWidget {
  const _MoreOptionsButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.watch<BroadcastBloc>();
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () => context.showModal<void>(
        BroadcastInfoModal(broadcast: bloc.state.broadcast),
        isScrollControlled: true,
        useRootNavigator: true,
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.loading = false,
    this.onTap,
  });

  final String label;
  final bool loading;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return MPrimaryButton(
      label: label,
      onPressed: onTap,
      loading: loading,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor ?? colors.onPrimary,
        backgroundColor: backgroundColor ?? colors.primary,
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
