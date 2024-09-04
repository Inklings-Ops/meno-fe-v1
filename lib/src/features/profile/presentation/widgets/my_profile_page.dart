import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MyProfileBloc>();
    final recentlyLiveCubit = context.read<RecentlyLiveCubit>();

    Future<void> onRefresh() async {
      final  myProfile = bloc.stream.first;
      bloc.add(const MyProfileEvent.fetch());

      final  recentlyLive = recentlyLiveCubit.stream.first;
      await recentlyLiveCubit.fetch();

      await Future.wait([myProfile, recentlyLive]);
    }

    return BlocListener<ProfileFormCubit, ProfileFormState>(
      listener: (context, state) {
        state.onEdited.fold(
          () => null,
          (either) => either.fold(
            (failure) => null,
            (success) => bloc.add(const MyProfileEvent.fetch()),
          ),
        );
      },
      child: BlocBuilder<MyProfileBloc, MyProfileState>(
        bloc: bloc,
        builder: (context, state) => Scaffold(
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: state.when(
              loading: () => const Center(child: MLoadingIndicator.box()),
              success: (profile) => CustomContent(profile: profile),
              failure: (_) => const Text('Oops, something unexpected happened'),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomContent extends HookWidget {
  const CustomContent({required this.profile, super.key});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final tabController = useTabController(initialLength: 4);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: true,
          expandedHeight: 340,
          backgroundColor: colors.background,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: Insets.large),
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
            onTap: () => context.push<void>(Routes.switchAccountSheet),
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
              onPressed: () => context.push(Routes.settings),
            ),
            Spaces.horizontalLarge,
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(32),
            child: SizedBox(
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
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          MAvatar(radius: 40, url: profile.imageUrl),
                          const SizedBox(width: 24),
                          Expanded(child: ProfileStats(stats: profile.stats)),
                        ],
                      ),
                    ),
                    Spaces.verticalLarge,
                    const AccountUpgradeSection(),
                    Spaces.verticalLarge,
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        SliverFillRemaining(
          child: TabBarView(
            controller: tabController,
            children: [
              const ProfileRecentBroadcastsTab(),
              EmptyStateWidget(actionTitle: 'Broadcasts', action: () {}),
              EmptyStateWidget(actionTitle: 'Favorites', action: () {}),
              EmptyStateWidget(actionTitle: 'Recordings', action: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
