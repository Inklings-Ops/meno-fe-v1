import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';
import 'package:meno_fe_v1/src/shared/widgets/empty_list_widget.dart';

class AllBroadcastsWidget extends StatelessWidget {
  const AllBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.verticalSpace,
        BlocBuilder<DAllCubit, DAllState>(
          buildWhen: (p, c) =>
              p.isNowLiveLoading != c.isNowLiveLoading ||
              p.nowLive != c.nowLive,
          builder: (context, state) => _Grid(
            title: 'Now Live',
            onSeeAll: () {},
            broadcasts: state.nowLive,
            isLoading: state.isNowLiveLoading,
            isNowLive: true,
          ),
        ),
        32.verticalSpace,
        BlocBuilder<DAllCubit, DAllState>(
          buildWhen: (p, c) =>
              p.isRecentlyLiveLoading != c.isRecentlyLiveLoading ||
              p.recentlyLive != c.recentlyLive,
          builder: (context, state) => _Grid(
            title: 'Recently Live',
            onSeeAll: () => context.push(Routes.recentlyLive),
            broadcasts: state.recentlyLive,
            isLoading: state.isRecentlyLiveLoading,
          ),
        ),
        32.verticalSpace,
      ],
    );
  }
}

class _Grid extends HookWidget {
  const _Grid({
    required this.title,
    required this.onSeeAll,
    required this.broadcasts,
    required this.isLoading,
    this.isNowLive = false,
  });
  final String title;
  final VoidCallback onSeeAll;
  final List<Broadcast?> broadcasts;
  final bool isLoading;
  final bool isNowLive;
  @override
  Widget build(BuildContext context) {
    late Widget child;
    if (isLoading) {
      child = const MLoadingIndicator.box();
    } else if (!isLoading && broadcasts.isEmpty) {
      child = const EmptyListWidget();
    } else {
      child = GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24.h,
          crossAxisSpacing: 24.w,
          childAspectRatio: (176.h / 176.w),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16).r,
        shrinkWrap: true,
        primary: false,
        itemCount: broadcasts.length,
        itemBuilder: (context, i) {
          final broadcast = broadcasts[i]!;
          if (isNowLive) {
            return MCard.live(
              title: broadcast.title.get()!,
              imageUrl: broadcast.imageUrl,
              host: broadcast.fullName!,
              liveCount: broadcast.totalListeners,
              onTap: () => context.showJoinLiveBroadcastModal(broadcast),
            );
          } else {
            return MCard.recentlyLive(
              title: broadcast.title.get()!,
              imageUrl: broadcast.imageUrl,
              host: broadcast.fullName!,
              onTap: () => context.push(Routes.details, extra: broadcast),
            );
          }
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(title: title, onSeeAll: onSeeAll),
        24.verticalSpace,
        LimitedBox(maxHeight: 376.h, child: child),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Container(
      height: 24.h,
      padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MText(title, style: MTextStyle.subheadingBold),
          InkWell(
            onTap: onSeeAll,
            child: MText(
              'See all',
              style: MTextStyle.microMedium,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
