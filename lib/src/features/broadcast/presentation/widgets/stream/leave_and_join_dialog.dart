import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/background_service.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';
import 'package:meno_fe_v1/src/services/socket/socket.dart';

class LeaveAndJoinDialog extends StatelessWidget {
  const LeaveAndJoinDialog({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final socket = context.read<SocketBloc>();
    final livekit = context.read<LiveKitBloc>();

    return AlertDialog(
      title: MText(
        'Already Streaming',
        style: textTheme.heading2Regular,
      ),
      contentPadding: const EdgeInsets.all(24),
      content: MText(
        '''You are currently in a live broadcast. Would you like to leave the broadcast or rejoin it?''',
        style: textTheme.captionRegular,
      ),
      actions: [
        SizedBox.fromSize(
          size: const Size(85, 40),
          child: MTextButton(
            label: 'Leave',
            onPressed: () {
              di<BackgroundService>().stopBroadcastBackgroundProcess();
              livekit.add(const LiveKitDisconnect());
              socket.add(SocketLeaveBroadcast(broadcast.id));
              router.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: colors.error,
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
        Spaces.horizontalLarge,
        SizedBox.fromSize(
          size: const Size(85, 40),
          child: MTextButton(
            label: 'Rejoin',
            onPressed: () => rejoin(context),
            style: TextButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
      ],
    );
  }

  void leave({required BuildContext context, bool shouldPop = true}) {
    final livekit = context.read<LiveKitBloc>().state.status;
    livekit.maybeMap(
      connecting: (value) => null,
      disconnected: (value) => null,
      failed: (value) => null,
      orElse: () {
        di<BackgroundService>().stopBroadcastBackgroundProcess();
        context.read<LiveKitBloc>().add(const LiveKitDisconnect());
      },
    );
    context.read<SocketBloc>().add(SocketLeaveBroadcast(broadcast.id));
    if (shouldPop) return router.pop<String?>('leave');
  }

  void rejoin(BuildContext context) {
    leave(context: context, shouldPop: false);
    router.pop<String?>('rejoin');
  }
}
