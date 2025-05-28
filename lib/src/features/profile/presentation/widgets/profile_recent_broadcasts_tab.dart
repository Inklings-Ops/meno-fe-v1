import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfileRecentBroadcastsTab extends HookWidget {
  const ProfileRecentBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersRecentBroadcastsBloc, UsersRecentBroadcastsState>(
      builder: (context, state) {
        switch (state) {
          case UsersRecentBroadcastsEmpty():
          case UsersRecentBroadcastsLoadFailure():
            return EmptyStateWidget(actionTitle: 'Broadcasts', action: () {});
          case UsersRecentBroadcastsInitial():
          case UsersRecentBroadcastsLoadInProgress():
            return _List(broadcasts: fakeBroadcasts, loading: true);
          case UsersRecentBroadcastsLoadMoreInProgress(:final broadcasts):
            return _List(broadcasts: broadcasts);
          case UsersRecentBroadcastsLoadSuccess(:final broadcasts):
            return _List(broadcasts: broadcasts);
          case UsersRecentBroadcastsLoadLastSuccess(:final broadcasts):
            return _List(broadcasts: broadcasts);
        }
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Skeletonizer(
        enabled: loading,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 56),
          separatorBuilder: (context, index) => Spaces.verticalLarge,
          itemCount: broadcasts.length + 1,
          itemBuilder: (context, index) {
            if (index < broadcasts.length) {
              final broadcast = broadcasts[index]!;
              return MRecentlyLiveListTile(
                title: broadcast.title.getOrCrash(),
                creator: broadcast.creator?.fullName.getOrNull() ??
                    broadcast.fullName?.getOrNull() ??
                    broadcast.creatorFullName?.getOrNull() ??
                    '',
                endTime: broadcast.endTime,
                imageUrl: broadcast.imageUrl,
                onTap: () => router.pushNamed(
                  'Broadcast Details',
                  pathParameters: {'id': broadcast.id.getOrCrash()},
                ),
              );
            }

            return const _LoadMoreWidget();
          },
        ),
      ),
    );
  }
}

class _LoadMoreWidget extends StatelessWidget {
  const _LoadMoreWidget();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersRecentBroadcastsBloc>();
    return BlocBuilder<UsersRecentBroadcastsBloc, UsersRecentBroadcastsState>(
      builder: (context, state) {
        switch (state) {
          case UsersRecentBroadcastsEmpty():
          case UsersRecentBroadcastsLoadFailure():
          case UsersRecentBroadcastsInitial():
          case UsersRecentBroadcastsLoadInProgress():
            return const SizedBox.shrink();
          case UsersRecentBroadcastsLoadMoreInProgress():
            return const MLoadingIndicator.box();
          case UsersRecentBroadcastsLoadSuccess():
            return TextButton(
              onPressed: () => bloc.add(
                const UsersRecentBroadcastsFetchMoreRequested(),
              ),
              child: const MText('Load more'),
            );
          case UsersRecentBroadcastsLoadLastSuccess():
            return MText(
              'You’ve reached the end 🎉',
              style: MTextTheme.of(context).captionRegular,
              color: MColorScheme.of(context).onBackgroundVariant,
              textAlign: TextAlign.center,
            );
        }
      },
    );
  }
}
