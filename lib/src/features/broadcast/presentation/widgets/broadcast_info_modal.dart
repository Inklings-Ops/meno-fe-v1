import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastInfoModal extends StatelessWidget {
  const BroadcastInfoModal({
    super.key,
    required this.broadcast,
    this.isStreaming = false,
  });
  final bool isStreaming;
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MAvatar(radius: 48.toScale, url: broadcast.imageUrl),
          $styles.spaces.verticalSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).radius,
            child: MText(
              broadcast.title.getOr(),
              style: $styles.text.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          $styles.spaces.verticalMicro,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).radius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.creator!.fullName,
                  style: $styles.text.captionRegular,
                ),
                $styles.spaces.horizontalSmall,
                const BroadcastStatusWidget(),
              ],
            ),
          ),
          24.vSpace,
          if (isStreaming) ...[
            MModalListTile(
              leading: const Icon(MIcons.arrow_narrow_down_left),
              title: 'Minimize Stream',
              onTap: () => context.go(Routes.home),
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
          if (!isStreaming)
            BlocBuilder<MenoBloc, MenoState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => const SizedBox(),
                live: () => MModalListTile(
                  leading: Icon(MIcons.trash, color: colors.error),
                  title: 'Delete Broadcast',
                  titleColor: colors.error,
                  onTap: () {
                    final id = broadcast.id;
                    context
                      ..read<BroadcastBloc>().add(BroadcastDeleteRequested(id))
                      ..pop();
                  },
                ),
              ),
            ),
          24.vSpace,
        ],
      ),
    );
  }
}
