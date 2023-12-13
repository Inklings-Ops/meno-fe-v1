import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/profile/domain/entities/profile.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/account_upgrade_section.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/empty_state_widget.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/profile_buttons.dart';
import 'package:meno_fe_v1/src/features/profile/presentation/widgets/profile_stats.dart';
import 'package:readmore/readmore.dart';

import '../../application/application.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myProfileProvider.future),
      child: switch (profile) {
        AsyncData(:final value) => _Content(profile: value!),
        AsyncError() => const Text('Oops, something unexpected happened'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Content extends HookWidget {
  const _Content({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 4);
    final colorScheme = MColorScheme.of(context)!;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          flexibleSpace: ProfileAppBar(
            name: profile.fullName.get()!,
          ),
        ),
      ],
      body: Column(
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
            child: ReadMoreText(
              profile.bio?.get() ?? "No bio",
              style: MTextStyle.captionRegular.copyWith(height: 1.3.h),
              trimLines: 3,
              trimMode: TrimMode.Line,
              trimExpandedText: "\nless",
              trimCollapsedText: "\nmore",
              moreStyle: MTextStyle.captionMedium.copyWith(
                color: colorScheme.onBackgroundVariant,
              ),
              lessStyle: MTextStyle.captionMedium.copyWith(
                color: colorScheme.onBackgroundVariant,
              ),
            ),
          ),
          MCore.large.verticalSpace,
          const ProfileButtons(),
          MCore.large.verticalSpace,
          SizedBox(
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
                Tab(text: "Recent broadcasts"),
                Tab(text: "All broadcasts"),
                Tab(text: "Favorites"),
                Tab(text: "Recordings"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                EmptyStateWidget(actionTitle: "Broadcasts", action: () {}),
                EmptyStateWidget(actionTitle: "Broadcasts", action: () {}),
                EmptyStateWidget(actionTitle: "Favorites", action: () {}),
                EmptyStateWidget(actionTitle: "Recordings", action: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
