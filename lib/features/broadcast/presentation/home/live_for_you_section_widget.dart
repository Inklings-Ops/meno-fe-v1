import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LiveForYouSectionWidget extends WatchingWidget {
  const LiveForYouSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final broadcasts = [fakeLiveBroadcast];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          padding: const .fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                width: 3,
                margin: const .symmetric(vertical: 2),
                color: colors.error,
              ),
              Spaces.horizontalMicro,
              MText(
                'Live For You',
                style: textTheme.heading3Bold,
                color: colors.onBackground,
              ),
              Spaces.horizontalSmall,
              Assets.images.sparkles.image(height: 24, width: 24),
              const Spacer(),
              InkWell(
                onTap: () => context.pushNamed(
                  R.broadcasts,
                  queryParameters: BroadcastQuery.nowLive().toRouterParams,
                ),
                child: MText('See all', color: colors.onBackgroundVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        LimitedBox(maxHeight: 184, child: _List(broadcasts: broadcasts)),
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
    if (broadcasts.isEmpty) return const MenoEmptyWidget();

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
