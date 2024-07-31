import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

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
        title: const MHeader(
          title: 'Discover',
          padding: EdgeInsets.zero,
          addTopMargin: true,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              const SizedBox(height: 6),
              DiscoverSearchBar(onTap: () => isSearching.value = true),
              Spaces.verticalXLarge,
              LimitedBox(
                maxHeight: 32,
                child: SearchFilterList(
                  filter: filter.value,
                  onSelected: (value) => filter.value = value,
                ),
              ),
              Spaces.verticalMicro,
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
