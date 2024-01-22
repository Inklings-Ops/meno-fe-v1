import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/auth/auth_bloc.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_list/broadcast_list_provider.dart';
import 'package:meno_fe_v1/src/features/profile/domain/entities/profile.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/account_upgrade_section.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/empty_state_widget.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/profile_buttons.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/profile_recent_broadcasts_tab.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/profile_stats.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';
import 'package:readmore/readmore.dart';

import '../../application/application.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.refresh(myProfileProvider.future),
          ref.refresh(myRecentBroadcastsProvider(limit: 8).future),
        ]),
        child: switch (profile) {
          AsyncData(:final value) => CustomContent(profile: value!),
          AsyncError() => const Text('Oops, something unexpected happened'),
          _ => const Center(child: CircularProgressIndicator()),
        },
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
              onPressed: () => context.read<AuthBloc>().add(
                    const AuthLogoutRequested(),
                  ),
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

class ProfileBio extends StatelessWidget {
  const ProfileBio({super.key, required this.bio});
  final IBio? bio;

  @override
  Widget build(BuildContext context) {
    final style = MTextStyle.captionMedium.copyWith(
      color: MColorScheme.of(context)!.onBackgroundVariant,
    );

    return ReadMoreText(
      bio?.get() ?? 'No bio',
      style: MTextStyle.captionRegular.copyWith(height: 1.3.h),
      trimLines: 3,
      trimMode: TrimMode.Line,
      trimExpandedText: '\nless',
      trimCollapsedText: '\nmore',
      moreStyle: style,
      lessStyle: style,
    );
  }
}
