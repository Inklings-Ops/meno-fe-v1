import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class NowLivePage extends HookWidget {
  const NowLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    final scrollController = useScrollController();
    final bloc = context.read<LiveBroadcastsBloc>();

    useEffect(
      () {
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300) {
            bloc.add(const GetMoreLiveBroadcasts());
          }
        });
        return () {};
      },
      const [],
    );

    return MScaffold(
      appBar: MAppBar.secondary(title: 'Now Live', centerTitle: true),
      padding: EdgeInsets.zero,
      body: RefreshIndicator.adaptive(
        onRefresh: () async => bloc.add(const GetLiveBroadcasts()),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 53),
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
            builder: (context, state) => state.maybeWhen(
              orElse: () => const Padding(
                padding: EdgeInsets.only(top: 16),
                child: EmptyListWidget(),
              ),
              loading: () => _List(broadcasts: fakeBroadcasts, loading: true),
              loaded: (broadcasts) => _List(broadcasts: broadcasts),
              loadingMore: (broadcasts) => Column(
                children: [
                  _List(broadcasts: broadcasts),
                  const Align(child: MLoadingIndicator.box()),
                ],
              ),
              loadedLast: (broadcasts) => Column(
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
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 159.50 / 176,
        ),
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        itemBuilder: (_, i) => LiveBroadcastCard(broadcast: broadcasts[i]!),
        itemCount: broadcasts.length,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
