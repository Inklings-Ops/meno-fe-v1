import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class StreamLeaveButton extends StatelessWidget {
  const StreamLeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final socket = context.read<SocketBloc>();

    final broadcast = context.select((StreamBloc bloc) => bloc.state.broadcast);

    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return MPrimaryButton.icon(
      label: 'Leave Broadcast',
      onPressed: () {
        context.showLeaveBroadcastDialog().then((value) {
          if (value != true) return;
          if (context.mounted) {
            di<BackgroundService>().stopBroadcastBackgroundProcess();
            socket.add(SocketLeaveBroadcast(broadcast.id));
            context.read<LiveKitBloc>().add(const LiveKitDisconnect());
            context.read<LiveBloc>().add(const LiveReset());
            router.go(Routes.home);
          }
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
