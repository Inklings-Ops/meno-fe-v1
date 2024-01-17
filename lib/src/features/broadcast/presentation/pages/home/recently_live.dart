import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../application/broadcast_list/broadcast_list_provider.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_list_widget.dart';

class RecentlyLive extends ConsumerWidget {
  const RecentlyLive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcasts = ref.watch(recentBroadcastsProvider());

    if (broadcasts.isLoading) {
      return const _BuildColumn(child: _SkeletonList());
    }

    if (broadcasts.hasValue && broadcasts.value?.isNotEmpty == true) {
      return _BuildColumn(
        child: BroadcastListWidget(
          itemCount: broadcasts.value!.length,
          itemBuilder: (context, i) => _RecentlyLiveCard(
            broadcast: broadcasts.value![i]!,
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

class _BuildColumn extends StatelessWidget {
  final Widget child;
  const _BuildColumn({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MCore.xxxLarge.verticalSpace,
        MHeader(
          title: 'Recently Live',
          actionTitle: 'See all',
          action: () => context.push(Routes.recentlyLive),
        ),
        24.verticalSpace,
        LimitedBox(maxHeight: 176, child: child),
      ],
    );
  }
}

class _RecentlyLiveCard extends HookConsumerWidget {
  final Broadcast broadcast;

  const _RecentlyLiveCard({required this.broadcast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MCard.recentlyLive(
      title: broadcast.title.get()!,
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
