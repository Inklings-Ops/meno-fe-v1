import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchBloc(facade: di<IBroadcastFacade>())),
        BlocProvider(
          create: (_) => FilterBloc(facade: di<IBroadcastFacade>())..init(),
        ),
      ],
      child: const DiscoverView(),
    );
  }
}

class DiscoverView extends HookWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    final isSearching = useState<bool>(false);
    final scrollController = useScrollController();

    final filter = useState<Filter>(Filter.all);

    useEffect(
      () {
        scrollController.addListener(() {
          final pixels = scrollController.position.pixels;
          final maxScrollExtent =
              scrollController.position.maxScrollExtent - 350;
          if (pixels >= maxScrollExtent) {
            fetchMore(context, filter.value);
          }
        });
        return null;
      },
      const [],
    );

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

  Future<dynamic> refresh(BuildContext context, Filter filter) async {
    return switch (filter) {
      Filter.all => Future.wait([_nowLive(context), _recentlyLive(context)]),
      Filter.nowLive => _nowLive(context),
      Filter.recentlyLive => _recentlyLive(context),
    };
  }

  Future<dynamic> _nowLive(BuildContext context) async {
    final nowLiveBloc = context.read<LiveBroadcastsBloc>();
    final nowLive = nowLiveBloc.stream.first;
    nowLiveBloc.add(const GetLiveBroadcasts());
    return Future<dynamic>.value(nowLive);
  }

  Future<dynamic> _recentlyLive(BuildContext context) async {
    final recentlyLiveBloc = context.read<RecentlyLiveCubit>();
    final recentlyLive = recentlyLiveBloc.stream.first;
    await recentlyLiveBloc.fetch();
    return Future<dynamic>.value(recentlyLive);
  }

  Future<void> fetchMore(BuildContext context, Filter filter) async {
    final nowLive = context.read<LiveBroadcastsBloc>();
    final recentlyLive = context.read<RecentlyLiveCubit>();

    return switch (filter) {
      Filter.all => null,
      Filter.nowLive => nowLive.add(const GetMoreLiveBroadcasts()),
      Filter.recentlyLive => recentlyLive.fetchMore(),
    };
  }
}
