import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NowLiveSectionWidget extends WatchingWidget {
  const NowLiveSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final broadcasts = watchValue((NowLiveBroadcastsManager m) => m.broadcasts);

    final isLoading = watchValue(
      (NowLiveBroadcastsManager m) => m.initialize.isRunning,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            onTap: () => context.pushNamed(
              R.broadcasts,
              queryParameters: BroadcastQuery.nowLive().toRouterParams,
            ),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        const SizedBox(height: 24),
        LimitedBox(
          maxHeight: 184,
          child: _List(
            broadcasts: isLoading ? fakeBroadcasts : broadcasts,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.isLoading = false});

  final List<Broadcast?> broadcasts;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) return const EmptyListWidget();

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: broadcasts.length,
        itemBuilder: (_, i) => LiveBroadcastCard(broadcast: broadcasts[i]!),
        primary: false,
      ),
    );
  }
}
