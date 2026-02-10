import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MyProfilePage extends WatchingWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userId = watchValue((UserManager m) => m.currentUserId);
    return const MyProfileView();
  }
}

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // final bloc = context.read<MyProfileCubit>();
    // final recentlyLiveCubit = context.read<RecentlyLiveBloc>();

    Future<void> onRefresh() async {
      // final myProfile = bloc.stream.first;
      // await bloc.fetch();
      //
      // final recentlyLive = recentlyLiveCubit.stream.first;
      // recentlyLiveCubit.add(const RecentlyLiveStarted());
      //
      // await Future.wait([myProfile, recentlyLive]);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Center(
            child: MPrimaryButton(
              label: 'Log out',
              onPressed: di<AuthManager>().logout.run,
            ),
          ),
        ],
      ),
    );
  }
}

// class _Scaffold extends HookWidget {
//   const _Scaffold({required this.profile, this.loading = false});
//
//   final Profile profile;
//   final bool loading;
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = MColorScheme.of(context);
//     final textTheme = MTextTheme.of(context);
//     final tabController = useTabController(initialLength: 4);
//
//     return Skeletonizer(
//       enabled: loading,
//       child: Scaffold(
//         body: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             SliverAppBar(
//               expandedHeight: 340,
//               backgroundColor: colors.background,
//               pinned: true,
//               leading: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: Insets.lg),
//                   child: ColoredBox(
//                     color: colors.secondary,
//                     child: const SizedBox(height: 30, width: 3),
//                   ),
//                 ),
//               ),
//               titleTextStyle: textTheme.heading3Bold,
//               leadingWidth: 23,
//               collapsedHeight: 58,
//               titleSpacing: 0,
//               title: GestureDetector(
//                 // onTap: () => context.push(R.switchAccountModal),
//                 child: Row(
//                   children: [
//                     MText(
//                       profile.fullName.getOrCrash(),
//                       color: colors.onBackground,
//                     ),
//                     Spaces.horizontalSmall,
//                     const Icon(MIcons.chevron_down, size: 24),
//                   ],
//                 ),
//               ),
//               actions: [
//                 MIconButton(
//                   icon: const Icon(MIcons.settings),
//                   color: colors.primary,
//                   onPressed: () => context.push(R.settings),
//                 ),
//                 Spaces.horizontalLarge,
//               ],
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(32),
//                 child: Container(
//                   color: colors.background,
//                   height: 32,
//                   child: TabBar(
//                     controller: tabController,
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     labelStyle: textTheme.captionMedium,
//                     isScrollable: true,
//                     tabAlignment: TabAlignment.start,
//                     labelPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 6,
//                     ),
//                     tabs: const [
//                       Tab(text: 'Recent broadcasts'),
//                       Tab(text: 'All broadcasts'),
//                       Tab(text: 'Favorites'),
//                       Tab(text: 'Recordings'),
//                     ],
//                   ),
//                 ),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 background: SafeArea(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(
//                       16,
//                       kToolbarHeight,
//                       16,
//                       0,
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             MAvatar(radius: 40, url: profile.imageUrl),
//                             const SizedBox(width: 24),
//                             // Expanded(child: ProfileStats(stats: profile.stats)),
//                           ],
//                         ),
//                         Spaces.verticalLarge,
//                         // const AccountUpgradeSection(),
//                         Spaces.verticalLarge,
//                         // Align(
//                         //   alignment: Alignment.centerLeft,
//                         //   child: ProfileBio(bio: profile.bio),
//                         // ),
//                         Spaces.verticalLarge,
//                         // const ProfileButtons(),
//                         Spaces.verticalLarge,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//           body: CustomScrollView(
//             primary: false,
//             slivers: [
//               SliverFillRemaining(
//                 child: Padding(
//                   padding: MediaQuery.viewInsetsOf(context),
//                   child: TabBarView(
//                     controller: tabController,
//                     children: [
//                       // const _RecentBroadcastsTab(),
//                       // const _AllBroadcastsTab(),
//                       // EmptyStateWidget(actionTitle: 'Favorites', action: () {}),
//                       // EmptyStateWidget(
//                       //   actionTitle: 'Recordings',
//                       //   action: () {},
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _RecentBroadcastsTab extends StatelessWidget {
//   const _RecentBroadcastsTab();
//
//   @override
//   Widget build(BuildContext context) {
//     final profileBloc = context.read<MyProfileCubit>();
//     final recentlyLiveBloc = context.read<UsersRecentBroadcastsBloc>();
//
//     Future<void> onRefresh() async {
//       final myProfile = profileBloc.stream.first;
//       await profileBloc.fetch();
//
//       final recentlyLive = recentlyLiveBloc.stream.first;
//       recentlyLiveBloc.add(const UsersRecentBroadcastsFetchRequested());
//
//       await Future.wait([myProfile, recentlyLive]);
//     }
//
//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: const ProfileRecentBroadcastsTab(),
//     );
//   }
// }
//
// class _AllBroadcastsTab extends StatelessWidget {
//   const _AllBroadcastsTab();
//
//   @override
//   Widget build(BuildContext context) {
//     final profileBloc = context.read<MyProfileCubit>();
//     final allBroadcastsBloc = context.read<UsersAllBroadcastsBloc>();
//
//     Future<void> onRefresh() async {
//       final myProfile = profileBloc.stream.first;
//       await profileBloc.fetch();
//
//       final allBroadcasts = allBroadcastsBloc.stream.first;
//       allBroadcastsBloc.add(const UsersAllBroadcastsFetchRequested());
//
//       await Future.wait([myProfile, allBroadcasts]);
//     }
//
//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: const ProfileAllBroadcastsTab(),
//     );
//   }
// }
