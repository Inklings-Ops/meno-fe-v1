import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select<SessionBloc, Uid<User>?>(
      (b) => b.state.whenOrNull(authenticated: (u, _) => u.id),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UsersRecentBroadcastsBloc(
            facade: di<IBroadcastFacade>(),
            userId: userId!,
          )..add(const GetUsersRecentBroadcasts()),
        ),
        BlocProvider(
          create: (_) => UsersAllBroadcastsBloc(
            facade: di<IBroadcastFacade>(),
            userId: userId!,
          )..add(const GetUsersBroadcasts()),
        ),
      ],
      child: const MyProfileView(),
    );
  }
}

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MyProfileCubit>();
    final recentlyLiveCubit = context.read<RecentlyLiveCubit>();

    Future<void> onRefresh() async {
      final myProfile = bloc.stream.first;
      await bloc.fetch();

      final recentlyLive = recentlyLiveCubit.stream.first;
      await recentlyLiveCubit.fetch();

      await Future.wait([myProfile, recentlyLive]);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileFormCubit, ProfileFormState>(
          listener: (context, state) {
            state.onEdited.fold(
              () => null,
              (either) => either.fold(
                (failure) => context.showErrorSnackBar(
                  failure.maybeWhen(
                    message: (message) => message,
                    networkError: () => MErrorMessages.networkError,
                    serverError: () => MErrorMessages.serverError,
                    timeOutError: () => MErrorMessages.timeOutError,
                    orElse: () => MErrorMessages.unknownError,
                  ),
                ),
                (success) => bloc.fetch(),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<MyProfileCubit, MyProfileState>(
        bloc: bloc,
        builder: (context, state) => Scaffold(
          body: state.when(
            loading: () => _Scaffold(profile: fakeProfile, loading: true),
            success: (profile) => _Scaffold(profile: profile),
            failure: (exception) => Center(
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
        ),
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
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    final tabController = useTabController(initialLength: 4);

    return Skeletonizer(
      enabled: loading,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 340,
              backgroundColor: colors.background,
              pinned: true,
              leading: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: Insets.lg),
                  child: ColoredBox(
                    color: colors.secondary!,
                    child: const SizedBox(height: 30, width: 3),
                  ),
                ),
              ),
              titleTextStyle: textTheme.heading3Bold,
              leadingWidth: 23,
              collapsedHeight: 58,
              titleSpacing: 0,
              title: GestureDetector(
                onTap: () => router.push(Routes.switchAccountModal),
                child: Row(
                  children: [
                    MText(profile.fullName.getOr(), color: colors.onBackground),
                    Spaces.horizontalSmall,
                    const Icon(MIcons.chevron_down, size: 24),
                  ],
                ),
              ),
              actions: [
                MIconButton(
                  icon: const Icon(MIcons.settings),
                  color: colors.primary,
                  onPressed: () => router.push(Routes.settings),
                ),
                Spaces.horizontalLarge,
              ],
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
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      kToolbarHeight,
                      16,
                      0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            MAvatar(radius: 40, url: profile.imageUrl),
                            const SizedBox(width: 24),
                            Expanded(child: ProfileStats(stats: profile.stats)),
                          ],
                        ),
                        Spaces.verticalLarge,
                        const AccountUpgradeSection(),
                        Spaces.verticalLarge,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ProfileBio(bio: profile.bio),
                        ),
                        Spaces.verticalLarge,
                        const ProfileButtons(),
                        Spaces.verticalLarge,
                      ],
                    ),
                  ),
                ),
              ),
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
                    children: [
                      const _RecentBroadcastsTab(),
                      const _AllBroadcastsTab(),
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
    final profileBloc = context.read<MyProfileCubit>();
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
    final profileBloc = context.read<MyProfileCubit>();
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
