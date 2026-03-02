import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentlyLiveSectionWidget extends WatchingWidget {
  const RecentlyLiveSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final broadcasts = watchValue(
      (RecentlyLiveBroadcastsManager m) => m.broadcasts,
    );

    final isLoading = watchValue(
      (RecentlyLiveBroadcastsManager m) => m.fetch.isRunning,
    );

    final error = watchValue(
      (RecentlyLiveBroadcastsManager m) => m.fetch.errors,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MHeader(
          title: 'Recently Live',
          action: InkWell(
            onTap: () => context.pushNamed(
              R.broadcasts,
              queryParameters: BroadcastQuery.recentlyLive().toRouterParams,
            ),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        Spaces.verticalXLarge,
        if (error != null) ...[
          MenoErrorWidget(
            error: error.error,
            onRetry: () async {
              // TODO(gettoknowdavid): Handle retry logic not updating error
              // widget
            },
          ),
        ] else ...[
          LimitedBox(
            maxHeight: 184,
            child: switch (isLoading) {
              true => _List(broadcasts: fakeBroadcasts, loading: true),
              false => _List(broadcasts: broadcasts),
            },
          ),
        ],
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
      host: broadcast.effectiveCreatorName.getOrElse((_) => ''),
      imageUrl: broadcast.imageUrl,
      onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
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
      ),
    );
  }
}
