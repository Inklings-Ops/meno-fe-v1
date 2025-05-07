import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class AccountsSearchResults extends StatelessWidget {
  const AccountsSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AccountsSearchBloc>();
    return BlocBuilder<AccountsSearchBloc, AccountsSearchState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.isLoading) return const MLoadingIndicator.box();

        if (!state.isLoading &&
            state.keyword != null &&
            state.profiles.isEmpty) {
          return const _NoResultsWidget();
        }

        return Column(
          children: [
            _ResultList(profiles: state.profiles, loading: state.isLoading),
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
  const _ResultList({required this.profiles, this.loading = false});
  final List<Profile?> profiles;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 159.50 / 192,
        ),
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        itemBuilder: (context, i) => ProfileCard(profile: profiles[i]!),
        itemCount: profiles.length,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
      ),
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
