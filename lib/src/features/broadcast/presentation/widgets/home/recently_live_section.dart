import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentlyLiveSection extends StatelessWidget {
  const RecentlyLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Recently Live',
          action: InkWell(
            onTap: () => router.push(Routes.recentlyLive),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        Spaces.verticalXLarge,
        LimitedBox(
          maxHeight: 176,
          child: BlocBuilder<RecentlyLiveCubit, RecentlyLiveState>(
            builder: (context, state) => state.maybeWhen(
              orElse: () => const SizedBox(),
              loading: () => _List(broadcasts: fakeBroadcasts, loading: true),
              success: (broadcasts) => _List(broadcasts: broadcasts),
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MCard.recentlyLive(
      title: broadcast.title.getOr(),
      host: broadcast.creator?.fullName ??
          broadcast.fullName ??
          broadcast.creatorFullName ??
          '',
      imageUrl: broadcast.imageUrl,
      onTap: () => router.push(Routes.details, extra: broadcast),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, super.key, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: broadcasts.length,
        itemBuilder: (_, i) => _Card(broadcast: broadcasts[i]!),
        primary: false,
        shrinkWrap: true,
      ),
    );
  }
}
