import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/application/application.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastStartStopButton extends StatelessWidget {
  const BroadcastStartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveBloc, LiveState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const _Button('Start'),
        reconnecting: () => _Button('Stop', onTap: () => stop(context)),
        offAir: () => _Button('Stop', onTap: () => stop(context)),
        loading: () => const _Button('Start', loading: true),
        live: () => _Button('Stop', onTap: () => stop(context)),
        failure: () => _Button('Start', onTap: () => start(context)),
      ),
    );
  }

  Future<void> stop(BuildContext context) {
    final broadcast = context.read<BroadcastBloc>().state.broadcast;
    return context.showEndBroadcastDialog().then((result) {
      if (result != true) return;
      if (context.mounted) {
        di<BackgroundService>().stopBroadcastBackgroundProcess();
        context.read<ParticipantsBloc>().add(GetAllParticipants(broadcast.id));
        context.read<SocketBloc>().add(SocketEndBroadcast(broadcast.id));
        context.read<TimerCubit>().stop();
        context.read<LiveKitBloc>().add(const LiveKitDisconnect());
        context.read<ChatListBloc>().add(const ChatReset());
        context.read<LiveBloc>().add(const LiveReset());
      }
    });
  }

  Future<void> start(BuildContext context) async {
    context.read<LiveBloc>().add(const GoLoading());
    final broadcast = context.read<BroadcastBloc>().state.broadcast;
    final liveKit = context.read<LiveKitBloc>();
    liveKit.add(LiveKitBroadcast(token: broadcast.broadcastToken));
  }
}

class _Button extends StatelessWidget {
  const _Button(
    this.label, {
    this.onTap,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    final isStart = label == 'Start';

    final backgroundColor = isStart
        ? colors.primaryContainer?.withValues(alpha: 0.3)
        : colors.errorContainer?.withValues(alpha: 0.3);

    final foregroundColor = isStart ? colors.primary : colors.error;

    return MPrimaryButton(
      label: '$label broadcasting',
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
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
