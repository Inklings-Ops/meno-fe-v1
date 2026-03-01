import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/domain/value_objects/paged_list.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileBroadcastListWidget extends StatelessWidget {
  const ProfileBroadcastListWidget({
    required this.page,
    required this.errorWidgetBuilder,
    required this.emptyListWidgetBuilder,
    this.hasError = false,
    this.isLoading = false,
    super.key,
  });

  final PagedList<Broadcast?> page;
  final Widget Function(BuildContext context) errorWidgetBuilder;
  final Widget Function(BuildContext context) emptyListWidgetBuilder;
  final bool hasError;
  final bool isLoading;

  @override
  Widget build(BuildContext ctx) {
    if (hasError && page.items.isEmpty) return errorWidgetBuilder(ctx);
    if (!isLoading && page.items.isEmpty) return emptyListWidgetBuilder(ctx);
    return _BroadcastList(
      broadcasts: isLoading && page.isEmpty ? fakeBroadcasts : page.items,
      isLoading: isLoading && page.isEmpty,
      hasMore: page.hasMore,
    );
  }
}

class _BroadcastList extends StatelessWidget {
  const _BroadcastList({
    required this.broadcasts,
    required this.hasMore,
    this.isLoading = false,
  });

  final List<Broadcast?> broadcasts;
  final bool hasMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const .symmetric(horizontal: 16, vertical: 24),
          sliver: SliverList.separated(
            separatorBuilder: (_, __) => Spaces.verticalLarge,
            itemCount: broadcasts.length,
            itemBuilder: (context, index) {
              final broadcast = broadcasts[index];
              if (broadcast == null) return const SizedBox.shrink();
              return Skeletonizer(
                enabled: isLoading,
                child: _ListItem(
                  key: ValueKey(broadcast.id),
                  broadcast: broadcast,
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: _ListFooter(hasMore: hasMore)),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MRecentlyLiveListTile(
      title: broadcast.title.getOrCrash(),
      creator: broadcast.effectiveCreatorName.getOrNull(),
      endTime: broadcast.endTime,
      imageUrl: broadcast.imageUrl,
      onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.hasMore});

  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (hasMore) return const MLoadingIndicator.box();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: MText(
        "You've reached the end 🎉",
        style: MTextTheme.of(context).captionRegular,
        color: MColorScheme.of(context).onBackgroundVariant,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ProfileEmptyBroadcastsListWidget extends StatelessWidget {
  const ProfileEmptyBroadcastsListWidget({
    required this.actionTitle,
    required this.action,
    this.title,
    super.key,
  });

  final String? title;
  final String actionTitle;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Assets.images.liveForYou.image(height: 120, width: 120),
          MText(
            title ?? 'No broadcasts published yet',
            style: textTheme.captionMedium,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalLarge,
          SizedBox(
            height: 32,
            child: MSecondaryButton.icon(
              label: 'View $actionTitle',
              icon: Icon(MIcons.share, color: colorScheme.onBackground),
              onPressed: action,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                side: BorderSide(color: colorScheme.outlineVariant3),
                foregroundColor: colorScheme.onBackground,
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
