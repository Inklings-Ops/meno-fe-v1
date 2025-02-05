import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/background_service.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';
import 'package:meno_fe_v1/src/services/socket/socket.dart';

class PreStreamModal extends HookWidget {
  const PreStreamModal({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final background = di<BackgroundService>();
    final livekit = context.read<LiveKitBloc>();
    final live = context.watch<LiveBloc>();
    final socket = context.watch<SocketBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<StreamBloc, StreamState>(
          listener: (context, state) {
            state.status.whenOrNull(
              failure: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                error.whenOrNull(
                  message: (message) => showLeaveJoinDialog(context, message),
                );
                context.showBroadcastError(error);
              },
              streamJoined: (token) {
                background.startBroadcastBackgroundProcess(state.broadcast);
                livekit.add(LiveKitStream(token: token));
              },
            );
          },
        ),
        BlocListener<LiveKitBloc, LiveKitState>(
          listener: (context, state) {
            state.status.whenOrNull(
              failed: (error, isStream) {
                background.stopBroadcastBackgroundProcess();
                live.add(const GoFailure());
                context.showErrorSnackBar(error);
              },
              streamConnected: () {
                socket.add(SocketJoinBroadcast(broadcast.id));
                router.popAndPush(Routes.broadcastTab, extra: true);
              },
            );
          },
        ),
      ],
      child: MModal(
        title: 'Stream',
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.22,
          minChildSize: 0.22,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TopSection(broadcast: broadcast),
                  Spaces.verticalXLarge,
                  PreStreamDescriptionSection(broadcast: broadcast),
                  Spaces.verticalXLarge,
                  MHeader(
                    title: 'Recent Broadcasts',
                    showSideBorder: false,
                    padding: EdgeInsets.zero,
                    action: InkWell(
                      onTap: () {},
                      child: MText(
                        'See all',
                        color: MColorScheme.of(context).onBackgroundVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showLeaveJoinDialog(BuildContext context, String message) async {
    final hasLeave = message.contains('leave');
    final isNotRoute = router.state?.path != Routes.leaveAndJoinDialog;
    if (hasLeave && isNotRoute) {
      final response = await router.push<String?>(
        Routes.leaveAndJoinDialog,
        extra: broadcast,
      );
      if (response == 'rejoin' && context.mounted) {
        context.read<LiveBloc>().add(const GoLoading());
        context.read<StreamBloc>().add(StreamJoinPressed(broadcast.id));
      } else {
        router.pop();
      }
    }
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({required this.broadcast});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      height: 142,
      child: Row(
        children: [
          PreStreamArtwork(imageUrl: broadcast.imageUrl),
          Spaces.horizontalLarge,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.title.getOr(),
                  style: textTheme.subheadingMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                const MBadge.live(),
                const SizedBox(height: 6),
                // Fix this
                MText(
                  broadcast.fullName ??
                      broadcast.creator?.fullName ??
                      broadcast.creatorFullName ??
                      '',
                  style: textTheme.captionRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Spaces.verticalMedium,
                PreStreamActionButtons(broadcast: broadcast),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
