import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/_shared/manager/live_scope_manager.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PreStreamModal extends WatchingWidget {
  const PreStreamModal({required this.broadcastId, super.key});

  final Id broadcastId;

  static Future<void> show(BuildContext context, Id broadcastId) {
    final activeId = di<LiveScopeManager>().activeBroadcastId.value;
    if (activeId == broadcastId) return context.push(R.liveBroadcast);
    return context.push(R.preStream(broadcastId.getOrCrash()));
  }

  @override
  Widget build(BuildContext context) {
    callOnce((_) => di<StreamManager>().fetchBroadcast.run(broadcastId));

    final isLoading = watchValue<StreamManager, bool>(
      (manager) => manager.fetchBroadcast.isRunning,
    );

    final broadcast = watchValue<StreamManager, Broadcast>(
      (manager) => manager.broadcast,
    );

    return MModal(
      title: 'Stream',
      padding: const .fromLTRB(16, 0, 16, 0),
      builder: (context) {
        if (isLoading) return const _LoadingSheet();
        return _LoadedSheet(broadcast: broadcast);
      },
    );
  }
}

class _LoadedSheet extends WatchingWidget {
  const _LoadedSheet({required this.broadcast})
    : super(key: const Key('pre-stream-modal-loaded'));

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (StreamManager m) => m.saveBroadcastSession,
      handler: (context, result, cancel) {
        context.pop();
        context.push(R.liveSessionInitialization);
      },
    );

    return DraggableScrollableSheet(
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
              creatorId: broadcast.hostId,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingSheet extends StatelessWidget {
  const _LoadingSheet() : super(key: const Key('pre-stream-modal-loading'));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.22,
      child: _TopSection(broadcast: fakeLiveBroadcast, isLoading: true),
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({required this.broadcast, this.isLoading = false});

  final Broadcast broadcast;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    return LimitedBox(
      maxHeight: 142,
      child: Skeletonizer(
        enabled: isLoading,
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
                    broadcast.hostName.getOrElse((_) => ''),
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

    Widget imageWidget = Center(
      child: SizedBox(
        height: 142 * 0.4,
        child: switch (colors.brightness) {
          .dark => Assets.images.logoLight.svg(),
          _ => Assets.images.logoDark.svg(),
        },
      ),
    );

    if (url != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: url!,
        height: 142,
        width: 142,
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: Corners.lg,
            border: Border.all(color: colors.outlineVariant1),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const MShimmer(borderRadius: 16),
      );
    }

    return imageWidget;
  }
}

class PreStreamActionButtons extends WatchingWidget {
  const PreStreamActionButtons({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final stream = di<StreamManager>();
    final isJoining = watchValue((StreamManager m) => m.isRunning);

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: MPrimaryButton(
              label: 'Join',
              loading: isJoining,
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                textStyle: textTheme.microMedium,
              ),
              onPressed: () => stream.joinBroadcast.run(broadcast.id),
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

class PreStreamRecentBroadcastsSection extends WatchingWidget {
  const PreStreamRecentBroadcastsSection({required this.creatorId, super.key});

  final Id creatorId;

  @override
  Widget build(BuildContext context) {
    final query = BroadcastQuery.recentlyLive(creatorId: creatorId);
    final params = query.toRouterParams;

    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: query,
      );
    });

    return BroadcastSectionWidget(
      title: 'Recent Broadcasts',
      padding: .zero,
      maxContentHeight: 170,
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        padding: .zero,
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.rLive(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
          );
        },
      ),
    );
  }
}
