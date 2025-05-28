import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastsPage extends StatelessWidget {
  const BroadcastsPage({
    required this.type,
    required this.sortBy,
    required this.orderBy,
    this.page = 1,
    this.size = 10,
    this.startTimeExists,
    this.endTimeExists,
    this.include,
    this.status,
    this.creatorId,
    super.key,
  });

  final BroadcastsPageType type;
  final int page;
  final int size;
  final String sortBy;
  final OrderBy orderBy;
  final bool? startTimeExists;
  final bool? endTimeExists;
  final String? include;
  final String? status;
  final String? creatorId;

  @override
  Widget build(BuildContext context) {
    final fetch = BroadcastsFetchRequested(
      page: page,
      sortBy: sortBy,
      orderBy: orderBy,
      creatorId: creatorId != null ? ID.fromString(creatorId!) : null,
      endTimeExists: endTimeExists,
      include: include,
      startTimeExists: startTimeExists,
      status: status,
    );

    return BlocProvider(
      create: (_) => BroadcastsBloc(facade: di<IBroadcastFacade>())..add(fetch),
      child: MScaffold(
        appBar: MAppBar.secondary(title: type.title, centerTitle: true),
        padding: EdgeInsets.zero,
        body: Column(
          children: [
            Spaces.horizontalXLarge,
            const _SearchBar(key: Key('BroadcastsPageSearchBar')),
            const SizedBox(height: 2),
            Expanded(
              child: switch (type) {
                BroadcastsPageType.recently => const RecentlyLiveListWidget(),
                BroadcastsPageType.now => const NowLiveListWidget(),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum BroadcastsPageType { recently, now, forYou }

BroadcastsPageType stringToBroadcastPageType(String? value) {
  return switch (value) {
    'recently' => BroadcastsPageType.recently,
    'forYou' => BroadcastsPageType.forYou,
    _ => BroadcastsPageType.now,
  };
}

extension BroadcastsPageTypeX on BroadcastsPageType {
  String get title {
    return switch (this) {
      BroadcastsPageType.recently => 'Recently Live',
      BroadcastsPageType.now => 'Now Live',
      BroadcastsPageType.forYou => 'Live For You',
    };
  }
}

class _SearchBar extends HookWidget {
  const _SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final focusNode = useFocusNode();
    final debounce = useRef<Timer?>(null);

    useEffect(
      () {
        return debounce.value?.cancel;
      },
      const [],
    );

    void onSearchChange(String query) {
      // Cancel the previous timer if it exists
      if (debounce.value?.isActive ?? false) debounce.value!.cancel();

      // Start a new timer
      debounce.value = Timer(const Duration(milliseconds: 400), () {
        // When the timer fires (user stopped typing), update the search
        context.read<BroadcastsBloc>().add(BroadcastsKeywordsChanged(query));
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: MenoSearchBar(
        focusNode: focusNode,
        hintText: 'Search broadcasts',
        onChanged: onSearchChange,
        leading: Icon(MIcons.search, color: colors.disabled, size: 16),
      ),
    );
  }
}
