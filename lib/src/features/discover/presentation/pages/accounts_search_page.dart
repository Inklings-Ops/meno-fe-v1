import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class AccountsSearchPage extends HookWidget {
  const AccountsSearchPage({required this.onCancel, super.key});
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final bloc = context.read<AccountsSearchBloc>();
    useEffect(
      () {
        scrollController.addListener(() {
          final pixels = scrollController.position.pixels;
          final maxScrollExtent = scrollController.position.maxScrollExtent;
          if (pixels >= maxScrollExtent && bloc.state.hasMore) {
            final page = bloc.state.page + 1;
            bloc.add(AccountSearchResultsFetched(page));
          }
        });
        return null;
      },
      const [],
    );
    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: DiscoverSearchBar(
            height: 32,
            autofocus: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            showCancelButton: true,
            onCancel: onCancel,
            onChanged: (value) {
              bloc.add(AccountSearchKeywordChanged(value));
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: const AccountsSearchResults(),
      ),
    );
  }
}
