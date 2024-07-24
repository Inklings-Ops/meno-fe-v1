import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class PreStreamModal extends StatelessWidget {
  const PreStreamModal({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StreamBloc, StreamState>(
      listener: (context, state) {
        state.whenOrNull(
          failure: (exception) => context.showBroadcastError(exception),
          joinFailed: (error) => context.showErrorSnackBar(error.toString()),
          joinSuccess: (broadcast) {
            context.pop();
            context.read<LiveParticipantsBloc>().initialize(broadcast);
            context.read<ChatBloc>().initialize(broadcast);
            context.read<TimerCubit>()
              ..set(broadcast.startTime)
              ..start();
            context.push(Routes.stream, extra: broadcast);
          },
        );
      },
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
                  24.vSpace,
                  PreStreamDescriptionSection(broadcast: broadcast),
                  24.vSpace,
                  MHeader(
                    title: 'Recent Broadcasts',
                    showSideBorder: false,
                    padding: EdgeInsets.zero,
                    action: InkWell(
                      onTap: () {},
                      child: MText(
                        'See all',
                        color: MColorScheme.of(context)!.onBackgroundVariant,
                      ),
                    ),
                  )
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
  final Broadcast broadcast;

  const _TopSection({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142.toScale,
      child: Row(
        children: [
          PreStreamArtwork(imageUrl: broadcast.imageUrl),
          $styles.spaces.horizontalLarge,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.title.getOr(),
                  style: $styles.text.subheadingMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                6.vSpace,
                const MBadge.live(),
                6.vSpace,
                MText(
                  broadcast.creator == null
                      ? broadcast.fullName!
                      : broadcast.creator!.fullName,
                  style: $styles.text.captionRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                $styles.spaces.verticalMedium,
                PreStreamActionButtons(broadcast: broadcast),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
