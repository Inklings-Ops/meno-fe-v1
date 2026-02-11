import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastsPage extends WatchingWidget {
  const BroadcastsPage({required this.query, super.key});

  final BroadcastQuery query;

  @override
  Widget build(BuildContext context) {
    final type = query.type;
    if (type == null) {
      return const MenoErrorWidget(message: 'Broadcasts Type required');
    }

    pushScope(
      init: (getIt) {
        getIt.registerSingleton<BroadcastQuery>(query);

        getIt.registerLazySingleton<BroadcastsManager>(() {
          final manager = BroadcastsManager(
            repository: di<IBroadcastRepository>(),
            query: query,
          );
          manager.fetch.run();
          return manager;
        });
      },
    );

    return MScaffold(
      appBar: MAppBar.secondary(title: type.title, centerTitle: true),
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Spaces.horizontalXLarge,
          const _SearchBar(key: Key('BroadcastsPageSearchBar')),
          const SizedBox(height: 2),
          Expanded(child: _buildListForType(type)),
        ],
      ),
    );
  }

  Widget _buildListForType(BroadcastsType type) => switch (type) {
    BroadcastsType.nowLive => const NowLiveListWidget(),
    BroadcastsType.recentlyLive => const RecentlyLiveListWidget(),
    _ => const SizedBox.shrink(),
  };
}

extension BroadcastsTypeX on BroadcastsType {
  String get title {
    return switch (this) {
      BroadcastsType.recentlyLive => 'Recently Live',
      BroadcastsType.nowLive => 'Now Live',
      BroadcastsType.forYou => 'Live For You',
    };
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    // final focusNode = useFocusNode();
    // final debounce = useRef<Timer?>(null);
    //
    // useEffect(() {
    //   return debounce.value?.cancel;
    // }, const []);
    //
    // void onSearchChange(String query) {
    //   // Cancel the previous timer if it exists
    //   if (debounce.value?.isActive ?? false) debounce.value!.cancel();
    //
    //   // Start a new timer
    //   debounce.value = Timer(const Duration(milliseconds: 400), () {
    //     // When the timer fires (user stopped typing), update the search
    //     context.read<BroadcastsBloc>().add(BroadcastsKeywordsChanged(query));
    //   });
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: MenoSearchBar(
        // focusNode: focusNode,
        hintText: 'Search broadcasts',
        // onChanged: onSearchChange,
        leading: Icon(MIcons.search, color: colors.disabled, size: 16),
      ),
    );
  }
}
