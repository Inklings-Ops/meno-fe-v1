import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

const _debounceTime = Duration(milliseconds: 400);

class BroadcastsPage extends WatchingWidget {
  const BroadcastsPage({required this.queryParameters, super.key});

  final Map<String, String> queryParameters;

  @override
  Widget build(BuildContext context) {
    final query = BroadcastQuery.fromRouter(queryParameters);
    final type = query.type;

    if (type == null) {
      return const MenoErrorWidget(message: 'Broadcasts Type required');
    }

    final feedSource = createOnce(
      () => BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: query,
      ),
    );

    final focusNode = createOnce(FocusNode.new);
    final keywords = createOnce(() => ValueNotifier<String?>(null));
    final debouncedQuery = createOnce(() => keywords.debounce(_debounceTime));

    registerHandler(
      target: debouncedQuery,
      handler: (context, String value, _) => feedSource.updateKeywords(value),
    );

    final feedLayout = switch (type) {
      BroadcastsType.recentlyLive => FeedLayout.verticalList,
      _ => FeedLayout.grid,
    };

    final colors = MColorScheme.of(context);

    return MScaffold(
      appBar: MAppBar.secondary(
        title: type.title,
        centerTitle: true,
        actions: const [UserAvatarWidget(), Spaces.horizontalLarge],
      ),
      padding: .zero,
      body: Column(
        children: [
          Spaces.verticalLarge,
          Padding(
            padding: const .symmetric(horizontal: 16),
            child: MenoSearchBar(
              focusNode: focusNode,
              hintText: 'Search broadcasts',
              onChanged: (input) => keywords.value = input,
              leading: Icon(MIcons.search, color: colors.disabled, size: 16),
            ),
          ),
          Spaces.verticalMicro,
          Expanded(
            child: FeedWidget<Broadcast?>(
              feedSource: feedSource,
              layout: feedLayout,
              itemBuilder: broadcastItemBuilder(
                feedSource: feedSource,
                onTap: (b) => context.push(R.broadcast(b.id.getOrCrash())),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Function(BuildContext, Broadcast?) broadcastItemBuilder({
    required BroadcastFeedDataSource feedSource,
    required void Function(Broadcast) onTap,
  }) {
    return (context, item) {
      if (item == null) return const SizedBox.shrink();
      return switch (feedSource.currentQuery.type) {
        .recentlyLive => BroadcastCard.tile(item, onTap: () => onTap(item)),
        _ => BroadcastCard.live(item, onTap: () => onTap(item)),
      };
    };
  }
}
