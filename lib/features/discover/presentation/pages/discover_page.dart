import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/discover/applications/applications.dart';
import 'package:meno/features/discover/domain/filter.dart';
import 'package:meno/features/discover/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverPage extends WatchingWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSearchEnabled = createOnce(() => ValueNotifier<bool>(false));
    final filter = watchValue((DiscoverManager m) => m.filter);

    if (isSearchEnabled.value) {
      void onSearchCancelled() => isSearchEnabled.value = false;
      return DiscoverSearchView(onCancel: onSearchCancelled);
    }

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: _AppBar(filter: filter),
      body: switch (filter) {
        .all => const AllBroadcastsWidget(),
        .nowLive => const NowLiveBroadcastsWidget(),
        .recentlyLive => const RecentlyLiveBroadcastsWidget(),
        .accounts => const SuggestAccountsWidget(),
      },
    );
  }
}

class _AppBar extends WatchingWidget implements PreferredSizeWidget {
  const _AppBar({required this.filter});

  final Filter filter;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const MHeader(
        title: 'Discover',
        padding: EdgeInsets.zero,
        addTopMargin: true,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          children: [
            const SizedBox(height: 6),
            switch (filter) {
              .accounts => AccountsSearchBar(onTap: () {}),
              _ => DiscoverSearchBar(onTap: () {}),
            },
            Spaces.verticalXLarge,
            LimitedBox(
              maxHeight: 32,
              child: SearchFilterList(
                filter: filter,
                onSelected: di<DiscoverManager>().onChanged,
              ),
            ),
            Spaces.verticalMicro,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110 + kToolbarHeight);
}
