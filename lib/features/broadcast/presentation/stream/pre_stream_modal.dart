import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PreStreamModal extends WatchingWidget {
  const PreStreamModal._({required this.broadcast}) : super(key: null);
  final Broadcast broadcast;

  static Future<dynamic> show(BuildContext context, Broadcast broadcast) {
    return showModalBottomSheet<dynamic>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => PreStreamModal._(broadcast: broadcast),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creatorId = broadcast.effectiveCreatorId;

    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton(() {
          return ProfileRecentBroadcastsManager(
            broadcastFeedSource: di<IBroadcastFeedSource>(),
            userId: creatorId,
          );
        }, onCreated: (instance) => instance.fetch.run());
      },
    );

    return MModal(
      title: 'Stream',
      padding: const .fromLTRB(16, 0, 16, 0),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.22,
        minChildSize: 0.22,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(child: _TopSection(broadcast: broadcast)),
            const SliverToBoxAdapter(child: Spaces.verticalXLarge),
            SliverToBoxAdapter(
              child: PreStreamDescriptionSection(
                description: broadcast.description,
              ),
            ),
            const SliverToBoxAdapter(child: Spaces.verticalXLarge),
            SliverToBoxAdapter(
              child: PreStreamRecentBroadcastsSection(
                creatorId: broadcast.effectiveCreatorId,
              ),
            ),
            // const SliverToBoxAdapter(child: Spaces.verticalXLarge),
          ],
        ),
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({required this.broadcast});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    return LimitedBox(
      maxHeight: 164,
      child: Row(
        children: [
          PreStreamArtwork(url: broadcast.imageUrl),
          Spaces.horizontalLarge,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                MText(
                  broadcast.title.getOrCrash(),
                  style: textTheme.subheadingMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                const MBadge.live(),
                const SizedBox(height: 6),
                MText(
                  broadcast.effectiveCreatorName.getOrElse((_) => ''),
                  style: textTheme.captionRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Spaces.verticalMedium,
                PreStreamActionButtons(broadcast: broadcast),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PreStreamArtwork extends StatelessWidget {
  const PreStreamArtwork({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final hasImage = url != null;

    DecorationImage? image;

    if (hasImage) {
      image = DecorationImage(
        image: CachedNetworkImageProvider(url!, maxHeight: 240, maxWidth: 240),
        fit: BoxFit.cover,
      );
    }

    final placeholder = SizedBox(
      height: 142 * 0.4,
      child: switch (colors.brightness) {
        .dark => Assets.images.logoLight.svg(),
        _ => Assets.images.logoDark.svg(),
      },
    );

    return Container(
      height: 142,
      width: 142,
      decoration: BoxDecoration(
        borderRadius: Corners.lg,
        border: Border.all(color: colors.outlineVariant1),
        image: image,
      ),
      child: hasImage ? null : Center(child: placeholder),
    );
  }
}

class PreStreamActionButtons extends StatelessWidget {
  const PreStreamActionButtons({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: MPrimaryButton(
              label: 'Join',
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                textStyle: textTheme.microMedium,
              ),
              onPressed: () {},
            ),
          ),
          Spaces.horizontalSmall,
          Expanded(
            child: MSecondaryButton(
              label: 'Share',
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.outlineVariant3),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                textStyle: textTheme.microMedium,
                foregroundColor: colors.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreStreamDescriptionSection extends StatelessWidget {
  const PreStreamDescriptionSection({required this.description, super.key});

  final MultiLineString description;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(MIcons.menu_03, size: Insets.lg),
            Spaces.horizontalSmall,
            MText('Description', style: textTheme.subheadingMedium),
          ],
        ),
        Spaces.verticalLarge,
        MText(description.getOrCrash()),
      ],
    );
  }
}

typedef _RecentBroadcastsMgr = ProfileRecentBroadcastsManager;

class PreStreamRecentBroadcastsSection extends WatchingWidget {
  const PreStreamRecentBroadcastsSection({required this.creatorId, super.key});

  final Id creatorId;

  @override
  Widget build(BuildContext context) {
    final broadcasts = watchValue((_RecentBroadcastsMgr m) => m.broadcasts);
    final isLoading = watchValue((_RecentBroadcastsMgr m) => m.fetch.isRunning);
    final error = watchValue((_RecentBroadcastsMgr m) => m.fetch.errors);

    if (error != null && !isLoading) {
      return MenoErrorWidget(
        error: error,
        onRetry: di<_RecentBroadcastsMgr>().fetch.runAsync,
      );
    }

    if (broadcasts.isEmpty && !isLoading) return const SizedBox.shrink();

    final colors = MColorScheme.of(context);

    return Column(
      mainAxisSize: .min,
      children: [
        MHeader(
          title: 'Recent Broadcasts',
          showSideBorder: false,
          padding: EdgeInsets.zero,
          action: InkWell(
            onTap: () {
              final query = BroadcastQuery.recentlyLive(creatorId: creatorId);
              final params = query.toRouterParams;
              context.pushNamed(R.broadcasts, queryParameters: params);
            },
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        Spaces.verticalLarge,
        LimitedBox(
          maxHeight: 170,
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: .zero,
              separatorBuilder: (context, i) => const SizedBox(width: 24),
              itemCount: broadcasts.length,
              itemBuilder: (_, index) {
                final broadcast = broadcasts[index]!;
                return MCard.recentlyLive(
                  title: broadcast.title.getOrCrash(),
                  host: broadcast.effectiveCreatorName.getOrElse((_) => ''),
                  imageUrl: broadcast.imageUrl,
                  onTap: () =>
                      context.push(R.broadcast(broadcast.id.getOrCrash())),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
