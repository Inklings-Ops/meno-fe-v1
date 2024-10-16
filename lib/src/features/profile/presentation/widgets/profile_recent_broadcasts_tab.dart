import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ProfileRecentBroadcastsTab extends StatelessWidget {
  const ProfileRecentBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcasts = <Broadcast?>[];

    // if (broadcasts.isLoading) {
    //   return const _LoadingList();
    // }

    // if (broadcasts.hasError && !broadcasts.isLoading) {
    // return Container(
    //   margin: const EdgeInsets.only(top: 40).r,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Icon(Icons.refresh, size: 40.r),
    //       const MText(
    //         'Reload ',
    //         style: MTextStyle.captionMedium,
    //         textAlign: TextAlign.center,
    //       ),
    //     ],
    //   ),
    // );
    // }

    if (broadcasts.isEmpty) {
      return EmptyStateWidget(actionTitle: 'Broadcasts', action: () {});
    }

    return _LoadedList(broadcasts: broadcasts);
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
      physics: const NeverScrollableScrollPhysics(),
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

// class _LoadingList extends StatelessWidget {
//   const _LoadingList();

//   @override
//   Widget build(BuildContext context) {
//     return _BuildListView(
//       itemCount: 2,
//       itemBuilder: (context, _) => const MRecentlyLiveListTile(loading: true),
//     );
//   }
// }
