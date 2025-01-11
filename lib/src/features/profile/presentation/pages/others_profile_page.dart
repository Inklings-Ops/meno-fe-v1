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
  const _Scaffold({required this.profile, super.key, this.loading = false});
  final Profile profile;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final colors = MColorScheme.of(context)!;

    final tabController = useTabController(initialLength: 2);

    return Skeletonizer(
      enabled: loading,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: MText(profile.fullName.getOr()),
              centerTitle: true,
              expandedHeight: loading ? 320 : 287,
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
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ProfileBio(bio: profile.bio),
                        ),
                        Spaces.verticalLarge,
                        const SizedBox(
                          height: 35,
                          child: Row(
                            children: [
                              Expanded(child: SubscribeButton()),
                              Spaces.horizontalLarge,
                              Expanded(child: ShareProfileButton()),
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
                fillOverscroll: true,
                child: Padding(
                  padding: MediaQuery.viewInsetsOf(context),
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      ProfileRecentBroadcastsTab(),
                      ProfileAllBroadcastsTab(),
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
