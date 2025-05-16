import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class OthersProfilePage extends StatelessWidget {
  const OthersProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OthersProfileCubit, OthersProfileState>(
      builder: (context, state) => state.when(
        loading: () => _Scaffold(profile: fakeProfile, loading: true),
        failure: (exception) => MScaffold(
          body: Center(
            child: Text(
              exception.maybeWhen(
                message: (message) => message,
                networkError: () => MErrorMessages.networkError,
                serverError: () => MErrorMessages.serverError,
                timeOutError: () => MErrorMessages.timeOutError,
                orElse: () => MErrorMessages.unknownError,
              ),
            ),
          ),
        ),
        success: (profile) => _Scaffold(profile: profile),
      ),
    );
  }
}

class _Scaffold extends HookWidget {
  const _Scaffold({required this.profile, this.loading = false});
  final Profile profile;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final colors = MColorScheme.of(context);

    final tabController = useTabController(initialLength: 2);

    return Skeletonizer(
      enabled: loading,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: MText(profile.fullName.getOr()),
              centerTitle: true,
              expandedHeight: loading ? 320 : 320,
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
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    tabs: const [
                      Tab(text: 'Recent broadcasts'),
                      Tab(text: 'All broadcasts'),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ProfileBio(bio: profile.bio),
                        ),
                        Spaces.verticalLarge,
                        SizedBox(
                          height: 35,
                          child: Row(
                            children: [
                              Expanded(
                                child: SubscribeButton(
                                  profile: profile,
                                  showIcon: true,
                                ),
                              ),
                              Spaces.horizontalLarge,
                              const Expanded(child: ShareProfileButton()),
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
                  onPressed: () => router.push(
                    Routes.othersProfileOptionsModal,
                  ),
                ),
              ],
            ),
          ],
          body: CustomScrollView(
            primary: false,
            slivers: [
              SliverFillRemaining(
                child: Padding(
                  padding: MediaQuery.viewInsetsOf(context),
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      _RecentBroadcastsTab(),
                      _AllBroadcastsTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentBroadcastsTab extends StatelessWidget {
  const _RecentBroadcastsTab();

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<OthersProfileCubit>();
    final recentlyLiveBloc = context.read<UsersRecentBroadcastsBloc>();

    Future<void> onRefresh() async {
      final myProfile = profileBloc.stream.first;
      await profileBloc.fetch();

      final recentlyLive = recentlyLiveBloc.stream.first;
      recentlyLiveBloc.add(const GetUsersRecentBroadcasts());

      await Future.wait([myProfile, recentlyLive]);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const ProfileRecentBroadcastsTab(),
    );
  }
}

class _AllBroadcastsTab extends StatelessWidget {
  const _AllBroadcastsTab();

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<OthersProfileCubit>();
    final allBroadcastsBloc = context.read<UsersAllBroadcastsBloc>();

    Future<void> onRefresh() async {
      final myProfile = profileBloc.stream.first;
      await profileBloc.fetch();

      final allBroadcasts = allBroadcastsBloc.stream.first;
      allBroadcastsBloc.add(const GetUsersBroadcasts());

      await Future.wait([myProfile, allBroadcasts]);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const ProfileAllBroadcastsTab(),
    );
  }
}
