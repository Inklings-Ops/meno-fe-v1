import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfileAllBroadcastsTab extends HookWidget {
  const ProfileAllBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersAllBroadcastsBloc, UsersAllBroadcastsState>(
      builder: (context, state) {
        switch (state) {
          case UsersAllBroadcastsEmpty():
          case UsersAllBroadcastsLoadFailure():
            return EmptyStateWidget(actionTitle: 'Broadcasts', action: () {});
          case UsersAllBroadcastsInitial():
          case UsersAllBroadcastsLoadInProgress():
            return _List(broadcasts: fakeBroadcasts, loading: true);
          case UsersAllBroadcastsLoadMoreInProgress(:final broadcasts):
            return _List(broadcasts: broadcasts);
          case UsersAllBroadcastsLoadSuccess(:final broadcasts):
            return _List(broadcasts: broadcasts);
          case UsersAllBroadcastsLoadLastSuccess(:final broadcasts):
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
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
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
    final bloc = context.read<UsersAllBroadcastsBloc>();
    return BlocBuilder<UsersAllBroadcastsBloc, UsersAllBroadcastsState>(
      builder: (context, state) {
        switch (state) {
          case UsersAllBroadcastsEmpty():
          case UsersAllBroadcastsLoadFailure():
          case UsersAllBroadcastsInitial():
          case UsersAllBroadcastsLoadInProgress():
            return const SizedBox.shrink();
          case UsersAllBroadcastsLoadMoreInProgress():
            return const MLoadingIndicator.box();
          case UsersAllBroadcastsLoadSuccess():
            return TextButton(
              onPressed: () => bloc.add(
                const UsersAllBroadcastsFetchMoreRequested(),
              ),
              child: const MText('Load more'),
            );
          case UsersAllBroadcastsLoadLastSuccess():
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
