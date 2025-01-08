import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

final fakeProfile = Profile(
  id: 'id',
  fullName: SingleLineString(BoneMock.name),
  bio: Bio(BoneMock.paragraph),
  stats: UserStats(broadcasts: 0, subscribers: 0, subscriptions: 0),
);

class OthersProfilePage extends StatelessWidget {
  const OthersProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OthersProfileCubit, OthersProfileState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => _Scaffold(profile: fakeProfile, loading: true),
        // failure: (exception) => MScaffold(
        //   body: Center(
        //     child: Text(
        //       exception.maybeWhen(
        //         message: (message) => message,
        //         networkError: () => MErrorMessages.networkError,
        //         serverError: () => MErrorMessages.serverError,
        //         timeOutError: () => MErrorMessages.timeOutError,
        //         orElse: () => MErrorMessages.unknownError,
        //       ),
        //     ),
        //   ),
        // ),
        // success: (profile) => _Scaffold(profile: profile),
      ),
    );
  }
}

class _Scaffold extends HookWidget {
  const _Scaffold({required this.profile, super.key, this.loading = false});
  final Profile profile;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final colors = MColorScheme.of(context)!;
    const shape = RoundedRectangleBorder(borderRadius: Corners.sm);

    final tabController = useTabController(initialLength: 4);

    return Skeletonizer(
      enabled: loading,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: MText(profile.fullName.getOr()),
              centerTitle: true,
              expandedHeight: 287,
              pinned: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(32),
                child: Container(
                  color: colors.background,
                  height: 32,
                  child: TabBar(
                    controller: tabController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    labelStyle: textTheme.captionMedium,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    tabs: const [
                      Tab(text: 'Recent broadcasts'),
                      Tab(text: 'All broadcasts'),
                      Tab(text: 'Favorites'),
                      Tab(text: 'Recordings'),
                    ],
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(16, kToolbarHeight, 16, 0),
                    child: Column(
                      children: [
                        Spaces.verticalLarge,
                        Row(
                          children: [
                            MAvatar(radius: 40, url: profile.imageUrl),
                            const SizedBox(width: 24),
                            Expanded(child: ProfileStats(stats: profile.stats)),
                          ],
                        ),
                        Spaces.verticalLarge,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ProfileBio(bio: profile.bio),
                        ),
                        Spaces.verticalLarge,
                        SizedBox(
                          height: 35,
                          child: Row(
                            children: [
                              Expanded(
                                child: MSecondaryButton.icon(
                                  label: 'Subscribe',
                                  icon: const Icon(MIcons.users_check),
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: colors.primary!),
                                    textStyle: textTheme.microMedium,
                                    shape: shape,
                                  ),
                                ),
                              ),
                              Spaces.horizontalLarge,
                              Expanded(
                                child: MSecondaryButton.icon(
                                  label: 'Share profile',
                                  icon: Icon(
                                    MIcons.share,
                                    color: colors.onBackground,
                                  ),
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: colors.outlineVariant3!,
                                    ),
                                    foregroundColor: colors.onBackground,
                                    textStyle: textTheme.microMedium,
                                    shape: shape,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spaces.verticalLarge,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(MIcons.dots_horizontal),
                  iconSize: 24,
                  onPressed: () {},
                ),
              ],
            ),
          ],
          body: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: TabBarView(
              controller: tabController,
              children: [
                const ProfileRecentBroadcastsTab(),
                const ProfileAllBroadcastsTab(),
                EmptyStateWidget(
                  actionTitle: 'Favorites',
                  action: () {},
                ),
                EmptyStateWidget(
                  actionTitle: 'Recordings',
                  action: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// class _Scaffold extends HookWidget {
//   const _Scaffold({required this.profile, super.key, this.loading = false});
//   final Profile profile;
//   final bool loading;

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = MTextTheme.of(context)!;
//     final colors = MColorScheme.of(context)!;
//     const shape = RoundedRectangleBorder(borderRadius: Corners.sm);

//     final tabController = useTabController(initialLength: 4);
//     final scrollController = useScrollController();

//     return Skeletonizer(
//       enabled: loading,
//       child: Scaffold(
//         body: CustomScrollView(
//           controller: scrollController,
//           slivers: [
//             SliverAppBar(
//               title: MText(profile.fullName.getOr()),
//               centerTitle: true,
//               expandedHeight: 287,
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(32),
//                 child: SizedBox(
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
//                     padding:
//                         const EdgeInsets.fromLTRB(16, kToolbarHeight, 16, 0),
//                     child: Column(
//                       children: [
//                         Spaces.verticalLarge,
//                         Row(
//                           children: [
//                             MAvatar(radius: 40, url: profile.imageUrl),
//                             const SizedBox(width: 24),
//                             Expanded(child: ProfileStats(stats: profile.stats)),
//                           ],
//                         ),
//                         Spaces.verticalLarge,
//                         Container(
//                           alignment: Alignment.centerLeft,
//                           child: ProfileBio(bio: profile.bio),
//                         ),
//                         Spaces.verticalLarge,
//                         SizedBox(
//                           height: 35,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: MSecondaryButton.icon(
//                                   label: 'Subscribe',
//                                   icon: const Icon(MIcons.users_check),
//                                   onPressed: () {},
//                                   style: OutlinedButton.styleFrom(
//                                     side: BorderSide(color: colors.primary!),
//                                     textStyle: textTheme.microMedium,
//                                     shape: shape,
//                                   ),
//                                 ),
//                               ),
//                               Spaces.horizontalLarge,
//                               Expanded(
//                                 child: MSecondaryButton.icon(
//                                   label: 'Share profile',
//                                   icon: Icon(
//                                     MIcons.share,
//                                     color: colors.onBackground,
//                                   ),
//                                   onPressed: () {},
//                                   style: OutlinedButton.styleFrom(
//                                     side: BorderSide(
//                                       color: colors.outlineVariant3!,
//                                     ),
//                                     foregroundColor: colors.onBackground,
//                                     textStyle: textTheme.microMedium,
//                                     shape: shape,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Spaces.verticalLarge,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(MIcons.dots_horizontal),
//                   iconSize: 24,
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             SliverFillRemaining(
//               child: TabBarView(
//                 controller: tabController,
//                 children: [
//                   ProfileRecentBroadcastsTab(
//                     scrollController: scrollController,
//                   ),
//                   const ProfileAllBroadcastsTab(),
//                   EmptyStateWidget(
//                     actionTitle: 'Favorites',
//                     action: () {},
//                   ),
//                   EmptyStateWidget(
//                     actionTitle: 'Recordings',
//                     action: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
