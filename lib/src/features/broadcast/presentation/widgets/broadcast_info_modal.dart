import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastInfoModal extends StatelessWidget {
  const BroadcastInfoModal({
    required this.broadcast,
    super.key,
    this.isStreaming = false,
  });
  final bool isStreaming;
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MAvatar(radius: 48, url: broadcast.imageUrl),
          Spaces.verticalSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: MText(
              broadcast.title.getOrCrash(),
              style: textTheme.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spaces.verticalMicro,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.creator?.fullName.getOrNull() ??
                      broadcast.creatorFullName?.getOrNull() ??
                      broadcast.fullName?.getOrNull() ??
                      '',
                  style: textTheme.captionRegular,
                ),
                Spaces.horizontalSmall,
                const BroadcastStatusWidget(),
              ],
            ),
          ),
          Spaces.verticalXLarge,
          if (isStreaming) ...[
            MModalListTile(
              leading: const Icon(MIcons.arrow_narrow_down_left),
              title: 'Minimize Stream',
              onTap: () => router.go(Routes.home),
            ),
            const MModalListTile(
              leading: Icon(MIcons.user_minus_01),
              title: 'Unsubscribe',
            ),
          ],
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          // if (!isStreaming)
          //   BlocBuilder<LiveBloc, LiveState>(
          //     builder: (context, state) => state.maybeWhen(
          //       live: () => const SizedBox(),
          //       reconnecting: () => const SizedBox(),
          //       streaming: () => const SizedBox(),
          //       orElse: () => MModalListTile(
          //         leading: Icon(MIcons.trash, color: colors.error),
          //         title: 'Delete Broadcast',
          //         titleColor: colors.error,
          //         onTap: () {},
          //       ),
          //     ),
          //   ),
          Spaces.verticalXLarge,
        ],
      ),
    );
  }
}
