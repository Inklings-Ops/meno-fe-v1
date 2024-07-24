import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class RecentlyLive extends StatelessWidget {
  const RecentlyLive({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentlyLiveCubit, RecentlyLiveState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        loading: () => const _BuildColumn(child: _SkeletonList()),
        success: (broadcasts) => _BuildColumn(
          child: BroadcastListWidget(
            itemCount: 6,
            itemBuilder: (context, i) => _RecentlyLiveCard(
              broadcast: broadcasts[i]!,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildColumn extends StatelessWidget {
  final Widget child;
  const _BuildColumn({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        $styles.spaces.verticalXXXLarge,
        MHeader(
          title: 'Recently Live',
          action: InkWell(
            onTap: () => context.push(Routes.recentlyLive),
            child: MText(
              'See all',
              color: MColorScheme.of(context)!.onBackgroundVariant,
            ),
          ),
        ),
        24.vSpace,
        LimitedBox(maxHeight: 176.toScale, child: child),
      ],
    );
  }
}

class _RecentlyLiveCard extends StatelessWidget {
  const _RecentlyLiveCard({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MCard.recentlyLive(
      title: broadcast.title.getOr(),
      host: broadcast.fullName,
      imageUrl: broadcast.imageUrl,
      onTap: () => context.push(Routes.details, extra: broadcast),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return BroadcastListWidget(
      itemCount: 5,
      itemBuilder: (context, i) => MCard.recentlyLive(loading: true),
    );
  }
}
