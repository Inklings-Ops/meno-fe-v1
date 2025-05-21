import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchBloc(facade: di<IBroadcastFacade>()),
        ),
        BlocProvider(
          create: (_) => AccountsSearchBloc(facade: di<IAuthFacade>()),
        ),
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

    void onSearchBarTapped() => isSearching.value = true;
    void onSearchCancelled() => isSearching.value = false;

    if (isSearching.value) {
      return switch (filter.value) {
        Filter.accounts => AccountsSearchPage(onCancel: onSearchCancelled),
        _ => BroadcastsSearchPage(onCancel: onSearchCancelled),
      };
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
              switch (filter.value) {
                Filter.accounts => AccountsSearchBar(onTap: onSearchBarTapped),
                _ => DiscoverSearchBar(onTap: onSearchBarTapped),
              },
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
          padding: const EdgeInsets.only(bottom: Insets.xxxl),
          child: switch (filter.value) {
            Filter.all => const AllBroadcastsWidget(),
            Filter.nowLive => const NowLiveBroadcastsWidget(),
            Filter.recentlyLive => const RecentlyLiveBroadcastsWidget(),
            Filter.accounts => const SuggestAccountsWidget(),
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
      Filter.accounts => null,
    };
  }

  Future<dynamic> _nowLive(BuildContext context) async {
    final nowLiveBloc = context.read<NowLiveBloc>();
    final nowLive = nowLiveBloc.stream.first;
    nowLiveBloc.add(const NowLiveStarted());
    return Future<dynamic>.value(nowLive);
  }

  Future<dynamic> _recentlyLive(BuildContext context) async {
    final recentlyLiveBloc = context.read<RecentlyLiveBloc>();
    final recentlyLive = recentlyLiveBloc.stream.first;
    recentlyLiveBloc.add(const RecentlyLiveStarted());
    return Future<dynamic>.value(recentlyLive);
  }

  Future<void> fetchMore(BuildContext context, Filter filter) async {
    final nowLive = context.read<NowLiveBloc>();
    final recentlyLive = context.read<RecentlyLiveBloc>();

    return switch (filter) {
      Filter.all => null,
      Filter.nowLive => nowLive.add(const NowLiveFetchMoreRequested()),
      Filter.recentlyLive =>
        recentlyLive.add(const RecentlyLiveFetchMoreRequested()),
      Filter.accounts => null,
    };
  }
}
