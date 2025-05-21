import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<SearchBloc>();
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.isLoading) return const MLoadingIndicator.box();

        if (!state.isLoading &&
            state.keyword != null &&
            state.searchResults.isEmpty) {
          return const _NoResultsWidget();
        }

        return Column(
          children: [
            _ResultList(result: state.searchResults),
            Spaces.verticalXLarge,
            DiscoverPaginationIndicator(
              isLoading: bloc.state.isSearchingMore,
              hasMore: bloc.state.hasMore,
            ),
            Spaces.verticalXLarge,
          ],
        );
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.result});
  final List<Broadcast?> result;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 159.50 / 176,
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
      itemCount: result.length,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        final broadcast = result[i]!;
        if (broadcast.endTime == null) {
          return MCard.live(
            title: broadcast.title.getOr(),
            imageUrl: broadcast.imageUrl,
            host: broadcast.fullName,
            liveCount: broadcast.totalListeners,
            onTap: () => router.push(Routes.preStreamModal, extra: broadcast),
          );
        }

        return MCard.recentlyLive(
          title: broadcast.title.getOr(),
          imageUrl: broadcast.imageUrl,
          host: broadcast.fullName,
          onTap: () => router.pushNamed(
            'Broadcast Details',
            pathParameters: {'id': broadcast.id.getOr()},
          ),
        );
      },
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(
            height: 152,
            width: 152,
          ),
          Spaces.verticalXLarge,
          MText(
            'No Results',
            style: textTheme.heading3Bold,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalMicro,
          MText(
            'Try a new search',
            style: textTheme.bodyRegular,
            color: colors.inActiveContainer,
          ),
        ],
      ),
    );
  }
}
