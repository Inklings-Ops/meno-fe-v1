import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/recently_live/recently_live_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../auth/application/application.dart';
import '../../profile.dart';
import '../pages/profile_bio.dart';
import 'account_upgrade_section.dart';
import 'empty_state_widget.dart';
import 'profile_buttons.dart';
import 'profile_recent_broadcasts_tab.dart';
import 'profile_stats.dart';

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
              loading: () => const Center(child: CircularProgressIndicator()),
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
    final colorScheme = MColorScheme.of(context)!;

    final tabController = useTabController(initialLength: 4);

    final authBloc = context.read<AuthBloc>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: true,
          expandedHeight: 340.h,
          backgroundColor: colorScheme.background,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: MCore.large).r,
              child: ColoredBox(
                color: colorScheme.secondary!,
                child: SizedBox(height: 30.h, width: 3.w),
              ),
            ),
          ),
          titleTextStyle: MTextStyle.heading3Bold,
          leadingWidth: 23.r,
          collapsedHeight: 58.h,
          titleSpacing: 0.r,
          title: GestureDetector(
            onTap: () => context.showSwitchAccountSheet(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MText(profile.fullName.get()!, color: colorScheme.onBackground),
                MCore.small.horizontalSpace,
                const Icon(MIcons.chevron_down, size: 24),
              ],
            ),
          ),
          actions: [
            MIconButton(
              icon: const Icon(MIcons.log_out),
              color: colorScheme.primary,
              onPressed: () => authBloc.add(const AuthLogoutRequested()),
            ),
            MCore.large.horizontalSpace,
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(32.h),
            child: SizedBox(
              height: 32.h,
              child: TabBar(
                controller: tabController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                labelStyle: MTextStyle.captionMedium,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: MCore.large,
                  vertical: 6,
                ).r,
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
                padding: const EdgeInsets.only(top: kToolbarHeight).r,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                      child: Row(
                        children: [
                          MAvatar(radius: 40.r, url: profile.imageUrl),
                          24.horizontalSpace,
                          ProfileStats(stats: profile.stats),
                        ],
                      ),
                    ),
                    MCore.large.verticalSpace,
                    const AccountUpgradeSection(),
                    MCore.large.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                      child: ProfileBio(bio: profile.bio),
                    ),
                    MCore.large.verticalSpace,
                    const ProfileButtons(),
                    MCore.large.verticalSpace,
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
