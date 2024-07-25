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
      Future myProfile = bloc.stream.first;
      bloc.add(const MyProfileEvent.fetch());

      Future recentlyLive = recentlyLiveCubit.stream.first;
      recentlyLiveCubit.fetch();

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
  const CustomContent({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final tabController = useTabController(initialLength: 4);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: true,
          expandedHeight: 340.toScale,
          backgroundColor: colors.background,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: $styles.insets.large),
              child: ColoredBox(
                color: colors.secondary!,
                child: SizedBox(height: 30.toScale, width: 3.toScale),
              ),
            ),
          ),
          titleTextStyle: $styles.text.heading3Bold,
          leadingWidth: 23.toScale,
          collapsedHeight: 58.toScale,
          titleSpacing: 0,
          title: GestureDetector(
            onTap: () => context.showSwitchAccountSheet(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MText(profile.fullName.getOr(), color: colors.onBackground),
                $styles.spaces.horizontalSmall,
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
            $styles.spaces.horizontalLarge,
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(32.toScale),
            child: SizedBox(
              height: 32.toScale,
              child: TabBar(
                controller: tabController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
                labelStyle: $styles.text.captionMedium,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ).radius,
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
                padding: const EdgeInsets.only(top: kToolbarHeight).radius,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16).radius,
                      child: Row(
                        children: [
                          MAvatar(radius: 40.toScale, url: profile.imageUrl),
                          24.hSpace,
                          Expanded(child: ProfileStats(stats: profile.stats)),
                        ],
                      ),
                    ),
                    $styles.spaces.verticalLarge,
                    const AccountUpgradeSection(),
                    $styles.spaces.verticalLarge,
                    Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16).radius,
                      child: ProfileBio(bio: profile.bio),
                    ),
                    $styles.spaces.verticalLarge,
                    const ProfileButtons(),
                    $styles.spaces.verticalLarge,
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
