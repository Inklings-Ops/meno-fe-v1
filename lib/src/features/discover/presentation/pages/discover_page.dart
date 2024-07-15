import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart' hide Assets;
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/features/discover/presentation/widgets/all_broadcasts_widget.dart';

import '../widgets/now_live_broadcasts_widget.dart';
import '../widgets/recently_live_broadcasts_widget.dart';

class DiscoverPage extends HookWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSearching = useState<bool>(false);
    final scrollController = useScrollController();

    final filter = useState<Filter>(Filter.all);

    useEffect(() {
      scrollController.addListener(() {
        final pixels = scrollController.position.pixels;
        final maxScrollExtent = scrollController.position.maxScrollExtent - 350;
        if (pixels >= maxScrollExtent) {
          fetchMore(context, filter.value);
        }
      });
      return null;
    }, const []);

    if (isSearching.value) {
      return SearchPage(onCancel: () => isSearching.value = false);
    }

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        title: const MHeader(title: 'Discover', padding: EdgeInsets.zero),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(110.h),
          child: Column(
            children: [
              16.verticalSpace,
              DiscoverSearchBar(onTap: () => isSearching.value = true),
              24.verticalSpace,
              LimitedBox(
                maxHeight: 32.h,
                child: SearchFilterList(
                  filter: filter.value,
                  onSelected: (value) => filter.value = value,
                ),
              ),
              MCore.micro.verticalSpace,
            ],
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => refresh(context, filter.value),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: switch (filter.value) {
            Filter.all => const AllBroadcastsWidget(),
            Filter.nowLive => const NowLiveBroadcastsWidget(),
            Filter.recentlyLive => const RecentlyLiveBroadcastsWidget(),
          },
        ),
      ),
    );
  }

  Future<void> refresh(BuildContext context, Filter filter) async {
    return await switch (filter) {
      Filter.all => Future.wait([
          context.read<DAllCubit>().refreshNowLive(),
          context.read<DAllCubit>().refreshRecentlyLive(),
        ]),
      Filter.nowLive => context.read<DNowLiveCubit>().refresh(),
      Filter.recentlyLive => context.read<DRecentlyLiveCubit>().refresh(),
    };
  }

  Future<void> fetchMore(BuildContext context, Filter filter) async {
    final nowLiveBloc = context.read<DNowLiveCubit>();
    final recentlyLiveBloc = context.read<DRecentlyLiveCubit>();

    final nowLivePage = nowLiveBloc.state.page + 1;
    final recentlyLivePage = recentlyLiveBloc.state.page + 1;

    return await switch (filter) {
      Filter.all => null,
      Filter.nowLive => nowLiveBloc.fetch(nowLivePage),
      Filter.recentlyLive => recentlyLiveBloc.fetch(recentlyLivePage),
    };
  }
}


// class _LoadingIndicator extends StatelessWidget {
//   const _LoadingIndicator();
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FilterBloc, FilterState>(
//       buildWhen: (p, c) => p.isLoading != c.isLoading || p.hasMore != c.hasMore,
//       builder: (context, state) {
//         if (state.filter == Filter.all) return const SizedBox();
//         return DiscoverPaginationIndicator(
//           isLoading: state.isLoading,
//           hasMore: state.hasMore,
//         );
//       },
//     );
//   }
// }
