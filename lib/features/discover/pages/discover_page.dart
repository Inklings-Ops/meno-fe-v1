import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno/features/discover/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverPage extends WatchingWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = watchValue((DiscoverManager m) => m.filter);
    final isSearchOpened = watchValue((DiscoverManager m) => m.isSearchOpened);

    if (isSearchOpened) return const DiscoverSearchView();

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: const _AppBar(key: Key('discover-page-app-bar')),
      body: switch (filter) {
        .all => const AllBroadcastsWidget(),
        .nowLive => const NowLiveBroadcastsWidget(),
        .recentlyLive => const RecentlyLiveBroadcastsWidget(),
        .accounts => const SuggestAccountsWidget(),
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const MHeader(
        title: 'Discover',
        padding: EdgeInsets.zero,
        addTopMargin: true,
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Column(
          children: [
            SizedBox(height: 6),
            DiscoverSearchBar(readOnly: true),
            Spaces.verticalXLarge,
            LimitedBox(maxHeight: 32, child: SearchFilterList()),
            Spaces.verticalMicro,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110 + kToolbarHeight);
}
