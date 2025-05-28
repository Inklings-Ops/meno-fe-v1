import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class PreStreamModal extends HookWidget {
  const PreStreamModal({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final chatsBloc = context.watch<ChatListBloc>();
    final participantsBloc = context.watch<ParticipantsBloc>();
    final timerBloc = context.watch<TimerCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            if (state.status.isJoined) {
              final broadcastId = state.broadcast.id;
              chatsBloc.add(ChatGetMessagesRequested(broadcastId));
              participantsBloc.add(ParticipantsFetchRequested(broadcastId));
              timerBloc.setAndStart(state.broadcast.startTime);
              router.popAndPush(Routes.broadcastTab, extra: true);
            }
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
}

class _TopSection extends StatelessWidget {
  const _TopSection({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
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
                  broadcast.title.getOrCrash(),
                  style: textTheme.subheadingMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                const MBadge.live(),
                const SizedBox(height: 6),
                MText(
                  broadcast.fullName?.getOrNull() ??
                      broadcast.creator?.fullName.getOrNull() ??
                      broadcast.creatorFullName?.getOrNull() ??
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
