import 'dart:developer';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class RecentlyLiveSection extends StatelessWidget {
  const RecentlyLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Recently Live',
          action: InkWell(
            onTap: () => context.pushNamed(
              'Broadcasts',
              queryParameters: {
                'type': BroadcastsPageType.recently.name,
                'sort-by': 'endTime',
                'order-by': OrderBy.DESC.name,
                'end-time-exists': 'true',
                'include': 'totalListeners',
              },
            ),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        Spaces.verticalXLarge,
        LimitedBox(
          maxHeight: 176,
          child: BlocBuilder<RecentlyLiveBloc, RecentlyLiveState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              switch (state) {
                case RecentlyLiveLoadInProgress():
                  return _List(broadcasts: fakeBroadcasts, loading: true);
                case RecentlyLiveLoadSuccess(:final broadcasts):
                  return _List(broadcasts: broadcasts);
                case RecentlyLiveLoadFailure(:final exception):
                  log('Recently Live Exception: ${exception.message}');
                  return const EmptyListWidget();
                default:
                  return const SizedBox.shrink();
              }
            },
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
      title: broadcast.title.getOrCrash(),
      host: broadcast.creator?.fullName.getOrNull() ??
          broadcast.fullName?.getOrNull() ??
          broadcast.creatorFullName?.getOrNull() ??
          '',
      imageUrl: broadcast.imageUrl,
      onTap: () => router.pushNamed(
        'Broadcast Details',
        pathParameters: {'id': broadcast.id.getOrCrash()},
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.loading = false});
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
