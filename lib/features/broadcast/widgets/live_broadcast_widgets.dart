import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastArtworkWidget extends StatelessWidget {
  const BroadcastArtworkWidget({
    required this.imageUrl,
    this.radius = 48,
    this.outerBoxHeight = 144,
    this.outerBoxWidth = 152,
    this.boxPadding = const .symmetric(horizontal: 28, vertical: 16),
    super.key,
  });

  final String? imageUrl;
  final double radius;
  final double? outerBoxHeight;
  final double? outerBoxWidth;
  final EdgeInsetsGeometry? boxPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: outerBoxHeight,
      width: outerBoxWidth,
      padding: boxPadding,
      alignment: .center,
      child: MAvatar(radius: radius, url: imageUrl),
    );
  }
}

class BroadcastCreatorWidget extends StatelessWidget {
  const BroadcastCreatorWidget({required this.name, super.key});

  final SingleLineString name;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return MText(
      name.getOrCrash(),
      color: colors.onDisabledContainer,
      style: textTheme.captionRegular,
      maxLines: 1,
      overflow: .ellipsis,
      textAlign: .center,
    );
  }
}

class BroadcastTitleWidget extends StatelessWidget {
  const BroadcastTitleWidget({
    required this.title,
    this.maxLines = 2,
    this.padding = const .symmetric(horizontal: Insets.md),
    super.key,
  });

  final SingleLineString title;
  final int maxLines;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Padding(
      padding: padding,
      child: MText(
        title.getOrCrash(),
        maxLines: 2,
        textAlign: .center,
        style: textTheme.subheadingBold,
        overflow: .ellipsis,
      ),
    );
  }
}

class BroadcastStatusWidget extends WatchingWidget {
  const BroadcastStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final status = watchValue((LiveSessionManager m) => m.status);
    return switch (status) {
      .live => const MBadge.live(),
      .offAir => MBadge.offAir(context),
      .reconnecting => MBadge.reconnecting(context),
      _ => MBadge.offAir(context),
    };
  }
}

class BroadcastAboutTab extends WatchingWidget {
  const BroadcastAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    final desc = watchValue((LiveSessionManager m) => m.broadcast).description;
    return SingleChildScrollView(
      padding: const .symmetric(horizontal: Insets.lg),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const MenoSpacer.v(Insets.xl),
          const Row(
            children: [
              Icon(MIcons.menu_03, size: Insets.lg),
              Spaces.horizontalSmall,
              MenoText.subheading('About Broadcast', weight: .bold),
            ],
          ),
          const MenoSpacer.v(Insets.lg),
          MenoText.caption(desc.getOrNull() ?? '', weight: .regular),
        ],
      ),
    );
  }
}

class BroadcastListeningTab extends WatchingWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    final list = watchValue((ParticipantsManager m) => m.displayedParticipants);
    final hasMore = watchValue((ParticipantsManager m) => m.hasMore);
    final isLoading = watchValue((ParticipantsManager m) => m.isLoading);

    return Column(
      key: const Key('BroadcastListeningTab'),
      children: [
        Spaces.verticalXLarge,
        const ParticipantListHeaderWidget(),

        Spaces.verticalLarge,
        Expanded(child: ParticipantsGrid(list, isLoading: isLoading)),

        if (hasMore) ...[
          Spaces.verticalLarge,
          MSecondaryButton(
            label: 'Load More',
            onPressed: () => di<ParticipantsManager>().loadMore(),
          ),
        ],
      ],
    );
  }
}

class BroadcastOptionsButton extends WatchingWidget {
  const BroadcastOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const .fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () => BroadcastInfoModal.show(context),
    );
  }
}
