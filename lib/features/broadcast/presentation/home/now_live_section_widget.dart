import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/presentation/presentation.dart'
    show EmptyListWidget;
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NowLiveSectionWidget extends WatchingWidget {
  const NowLiveSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final broadcasts = watchValue((NowLiveBroadcastsManager m) => m.broadcasts);

    final isLoading = watchValue(
      (NowLiveBroadcastsManager m) => m.getBroadcasts.isRunning,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            // onTap: () => context.pushNamed(
            //   'Broadcasts',
            //   queryParameters: {
            //     'type': BroadcastsPageType.now.name,
            //     'sort-by': 'startTime',
            //     'order-by': OrderBy.ASC.name,
            //     'end-time-exists': 'false',
            //     'start-time-exists': 'true',
            //     'include': 'totalListeners',
            //     'status': 'active',
            //   },
            // ),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        const SizedBox(height: 24),
        LimitedBox(
          maxHeight: 184,
          child: switch (isLoading) {
            true => _List(broadcasts: fakeBroadcasts, loading: true),
            false => _List(broadcasts: broadcasts),
          },
        ),
      ],
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.loading = false});

  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) return const EmptyListWidget();

    return Skeletonizer(
      enabled: loading,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: broadcasts.length,
        itemBuilder: (_, i) => LiveBroadcastCard(broadcast: broadcasts[i]!),
        primary: false,
        shrinkWrap: true,
      ),
    );
  }
}
