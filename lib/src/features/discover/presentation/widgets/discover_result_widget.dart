import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/shared/widgets/empty_list_widget.dart';

class DiscoverResultWidget extends HookWidget {
  const DiscoverResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      buildWhen: (p, c) => p.filter != c.filter || p.isLoading != c.isLoading,
      builder: (context, state) {
        final isLoading = state.isLoading;
        final filter = state.filter;

        if (filter == Filter.all) return const _AllBroadcastsView();

        if (!isLoading && state.searchMap[filter]?.isEmpty == true) {
          return const Center(child: EmptyListWidget());
        }

        final broadcasts = state.searchMap[filter] ?? [];
        return DiscoverBroadcastGridView(
          broadcasts: broadcasts,
          filter: filter,
        );
      },
    );
  }
}

class _AllBroadcastsView extends HookWidget {
  const _AllBroadcastsView();

  Future<List<Broadcast?>> nowLive() async {
    final fOrS = await di<IDiscoverFacade>().fetchNowLive();
    return fOrS.fold((l) => [], (r) => r.broadcasts);
  }

  Future<List<Broadcast?>> recentlyLive() async {
    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(days: 100));

    final fOrS = await di<IDiscoverFacade>().fetchRecentlyLive(
      endTimeGT: oneDayAgo.toIso8601String(),
      endTimeLT: now.toIso8601String(),
    );
    return fOrS.fold((l) => [], (r) => r.broadcasts);
  }

  @override
  Widget build(BuildContext context) {
    final nowLiveFuture = useMemoized(nowLive);
    final nowLiveSnapshot = useFuture(nowLiveFuture);

    final recentlyLiveFuture = useMemoized(recentlyLive);
    final recentlyLiveSnapshot = useFuture(recentlyLiveFuture);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.verticalSpace,
        _Grid(
          title: 'Now Live',
          snapshot: nowLiveSnapshot,
          isNowLive: true,
          onSeeAll: () {},
        ),
        32.verticalSpace,
        _Grid(
          title: 'Recently Live',
          snapshot: recentlyLiveSnapshot,
          onSeeAll: () {},
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
    required this.snapshot,
    this.isNowLive = false,
  });
  final String title;
  final VoidCallback onSeeAll;
  final AsyncSnapshot<List<Broadcast?>> snapshot;
  final bool isNowLive;
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    late Widget child;

    final isLoading = snapshot.connectionState == ConnectionState.waiting;
    if (isLoading || snapshot.hasError) {
      child = const MLoadingIndicator.box();
    } else if (!isLoading && snapshot.data?.isEmpty == true) {
      child = const EmptyListWidget();
    } else {
      final broadcasts = snapshot.data!;
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
            );
          } else {
            return MCard.recentlyLive(
              title: broadcast.title.get()!,
              imageUrl: broadcast.imageUrl,
              host: broadcast.fullName!,
            );
          }
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
        ),
        24.verticalSpace,
        LimitedBox(maxHeight: 376.h, child: child),
      ],
    );
  }
}
