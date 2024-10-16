import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';



class RecentlyLivePage extends HookWidget {
  const RecentlyLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final bloc = context.read<RecentlyLiveCubit>();
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          bloc.fetchMore();
        }
      });
      return scrollController.dispose;
    }, const [],);

    return MScaffold(
      appBar: MAppBar.secondary(title: 'Recently Live', centerTitle: true),
      padding: EdgeInsets.zero,
      body: RefreshIndicator.adaptive(
        onRefresh: () async => bloc.fetch(),
        child: ListView(
          controller: scrollController,
          children: [
            BlocBuilder<RecentlyLiveCubit, RecentlyLiveState>(
              bloc: bloc,
              builder: (context, state) => state.maybeWhen(
                orElse: () => const SizedBox(),
                loading: () => const _LoadingList(),
                loadingMore: (broadcasts) => Column(
                  children: [
                    _LoadedList(broadcasts: broadcasts),
                    const Align(child: MLoadingIndicator.box()),
                  ],
                ),
                success: (broadcasts) => _LoadedList(broadcasts: broadcasts),
                successLast: (broadcasts) => Column(
                  children: [
                    _LoadedList(broadcasts: broadcasts),
                    Spaces.verticalLarge,
                    MText(
                      'You’ve reached the end 🎉',
                      style: textTheme.captionRegular,
                      color: colors.onBackgroundVariant,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 53),
          ],
        ),
      ),
    );
  }
}

class _BuildListView extends StatelessWidget {
  const _BuildListView({
    required this.itemCount,
    required this.itemBuilder,
  });
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      separatorBuilder: (context, index) => Spaces.verticalLarge,
    );
  }
}

class _LoadedList extends StatelessWidget {
  const _LoadedList({required this.broadcasts});
  final List<Broadcast?> broadcasts;

  @override
  Widget build(BuildContext context) {
    return _BuildListView(
      itemCount: broadcasts.length,
      itemBuilder: (context, index) {
        final broadcast = broadcasts[index]!;
        return MRecentlyLiveListTile(
          title: broadcast.title.getOr(),
          creator: broadcast.fullName,
          endTime: broadcast.endTime,
          imageUrl: broadcast.imageUrl,
          onTap: () => router.push(Routes.details, extra: broadcast),
        );
      },
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return _BuildListView(
      itemCount: 3,
      itemBuilder: (context, _) => const MRecentlyLiveListTile(loading: true),
    );
  }
}
