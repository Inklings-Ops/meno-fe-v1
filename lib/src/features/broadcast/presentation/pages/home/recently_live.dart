import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../application/recently_live/recently_live_cubit.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_list_widget.dart';

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
        MCore.xxxLarge.verticalSpace,
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
        24.verticalSpace,
        LimitedBox(maxHeight: 176, child: child),
      ],
    );
  }
}

class _RecentlyLiveCard extends StatelessWidget {
  final Broadcast broadcast;

  const _RecentlyLiveCard({required this.broadcast});

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
