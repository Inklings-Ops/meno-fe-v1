import 'package:flutter/material.dart';
import 'package:meno/features/discover/presentation/presentation.dart';
import 'package:meno/features/profile/domain/profile.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccountsSearchResults extends StatelessWidget {
  const AccountsSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ResultList(profiles: []),
        Spaces.verticalXLarge,
        DiscoverPaginationIndicator(isLoading: false, hasMore: false),
        Spaces.verticalXLarge,
      ],
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.profiles, this.loading = false});

  final List<Profile?> profiles;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 159.50 / 192,
        ),
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        itemBuilder: (context, i) => ProfileCard(profile: profiles[i]!),
        itemCount: profiles.length,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 152, width: 152),
          Spaces.verticalXLarge,
          MText(
            'No Results',
            style: textTheme.heading3Bold,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalMicro,
          MText(
            'Try a new search',
            style: textTheme.bodyRegular,
            color: colors.inActiveContainer,
          ),
        ],
      ),
    );
  }
}
