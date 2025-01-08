import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfileAllBroadcastsTab extends HookWidget {
  const ProfileAllBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersAllBroadcastsBloc>();

    final scrollController = useScrollController();

    useEffect(
      () {
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300) {
            bloc.add(const GetMoreUsersBroadcasts());
          }
        });
        return () {};
      },
      const [],
    );

    return BlocBuilder<UsersAllBroadcastsBloc, UsersAllBroadcastsState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => EmptyStateWidget(
          actionTitle: 'Broadcasts',
          action: () {},
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
              style: MTextTheme.of(context)?.captionRegular,
              color: MColorScheme.of(context)?.onBackgroundVariant,
              textAlign: TextAlign.center,
            ),
          ],
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
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        separatorBuilder: (context, index) => Spaces.verticalLarge,
        itemCount: broadcasts.length,
        itemBuilder: (context, index) {
          final broadcast = broadcasts[index]!;
          return MRecentlyLiveListTile(
            title: broadcast.title.getOr(),
            creator: broadcast.creator?.fullName ??
                broadcast.fullName ??
                broadcast.creatorFullName ??
                '',
            endTime: broadcast.endTime,
            imageUrl: broadcast.imageUrl,
            onTap: () => router.push(Routes.details, extra: broadcast),
          );
        },
      ),
    );
  }
}
