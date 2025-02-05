import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class RecentlyLivePage extends HookWidget {
  const RecentlyLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    final scrollController = useScrollController();
    final bloc = context.read<RecentlyLiveCubit>();

    useEffect(
      () {
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300) {
            bloc.fetchMore();
          }
        });
        return () {};
      },
      const [],
    );

    return MScaffold(
      appBar: MAppBar.secondary(title: 'Recently Live', centerTitle: true),
      padding: EdgeInsets.zero,
      body: RefreshIndicator.adaptive(
        onRefresh: () async => bloc.fetch(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 53),
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<RecentlyLiveCubit, RecentlyLiveState>(
            bloc: bloc,
            builder: (context, state) => state.maybeWhen(
              orElse: () => const Padding(
                padding: EdgeInsets.only(top: 16),
                child: EmptyListWidget(),
              ),
              loading: () => _List(broadcasts: fakeBroadcasts, loading: true),
              loadingMore: (broadcasts) => Column(
                children: [
                  _List(broadcasts: broadcasts),
                  const Align(child: MLoadingIndicator.box()),
                ],
              ),
              success: (broadcasts) => _List(broadcasts: broadcasts),
              successLast: (broadcasts) => Column(
                children: [
                  _List(broadcasts: broadcasts),
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
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        separatorBuilder: (context, index) => Spaces.verticalLarge,
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
      ),
    );
  }
}
