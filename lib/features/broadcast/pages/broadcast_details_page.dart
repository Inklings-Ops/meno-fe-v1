import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef _Manager = BroadcastDetailsManager;

class BroadcastDetailsPage extends WatchingWidget {
  const BroadcastDetailsPage({required this.broadcastIdStr, super.key});

  final String broadcastIdStr;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingletonAsync(() async {
          final manager = BroadcastDetailsManager(
            di<BroadcastHttpService>(),
            Id.fromString(broadcastIdStr),
          );
          await manager.fetch.runAsync();
          return manager;
        });
      },
    );

    final isFetching = watchValue((_Manager m) => m.fetch.isRunning);
    final broadcast = watchValue((_Manager m) => m.broadcast);
    final error = watchValue((_Manager m) => m.fetch.errors);

    if (isFetching) {
      return Skeletonizer(
        child: BroadcastDetailsView(broadcast: fakeLiveBroadcast),
      );
    }

    if (!isFetching && error != null) {
      return MScaffold(
        appBar: MAppBar.secondary(title: 'An error occurred'),
        body: MenoErrorWidget(
          error: error.error,
          onRetry: di<_Manager>().fetch.runAsync,
        ),
      );
    }

    if (broadcast == null) {
      return MScaffold(
        appBar: MAppBar.secondary(title: 'Not Found'),
        body: MenoErrorWidget(
          message: 'No broadcast found. Please try again.',
          onRetry: di<_Manager>().fetch.runAsync,
        ),
      );
    }

    return BroadcastDetailsView(broadcast: broadcast);
  }
}

class BroadcastDetailsView extends StatelessWidget {
  const BroadcastDetailsView({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(
        title: broadcast.title.getOrCrash(),
        actions: [
          MIconButton(icon: const Icon(MIcons.star_border), onPressed: () {}),
          Spaces.horizontalLarge,
          MIconButton(
            icon: const Icon(MIcons.dots_horizontal),
            onPressed: () {},
          ),
          Spaces.horizontalLarge,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Spaces.verticalLarge,
            Align(child: _Artwork(imageUrl: broadcast.imageUrl)),
            Spaces.verticalSmall,
            _Title(title: broadcast.title),
            Spaces.verticalMicro,
            _Creator(
              name: broadcast.effectiveCreatorName,
              onPressed: () {
                // TODO(gettoknowdavid): Handle navigation to user's profile
              },
            ),
            Spaces.verticalLarge,
            MPrimaryButton.icon(
              label: 'Restream',
              icon: const Icon(MIcons.play),
              onPressed: () {},
            ),
            Spaces.verticalLarge,
            const MDivider(),
            Spaces.verticalXLarge,
            _Description(description: broadcast.description),
          ],
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    const borderRadius = Corners.lg;

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade,
      BlendMode.srcIn,
    );

    Widget image = Center(
      child: Assets.images.logoLight.svg(colorFilter: colorFilter, height: 32),
    );

    if (imageUrl != null) {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const MShimmer(borderRadius: 16),
      );
    }

    return Container(
      width: 201,
      height: 128,
      decoration: BoxDecoration(
        color: colors.surfaceShade,
        borderRadius: borderRadius,
      ),
      child: image,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final SingleLineString title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return SizedBox(
      height: 24,
      child: MText(
        title.getOrCrash(),
        style: textTheme.subheadingMedium,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Creator extends StatelessWidget {
  const _Creator({required this.name, this.onPressed});
  final SingleLineString name;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return SizedBox(
      height: 16,
      child: MTextButton.icon(
        label: name.getOrCrash(),
        icon: const Icon(MIcons.chevron_right),
        iconPlacement: .right,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: colors.onBackgroundVariant,
          iconColor: colors.onBackgroundVariant,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({this.description});

  final MultiLineString? description;

  @override
  Widget build(BuildContext context) {
    if (description == null) return const SizedBox.shrink();

    final textTheme = MTextTheme.of(context);
    return Column(
      children: [
        Row(
          children: [
            const Icon(MIcons.menu_03, size: 16),
            Spaces.horizontalSmall,
            MText('About Broadcast', style: textTheme.subheadingMedium),
          ],
        ),
        Spaces.verticalLarge,
        Align(alignment: .centerLeft, child: MText(description!.getOrCrash())),
      ],
    );
  }
}

class _OptionsModal extends StatelessWidget {
  const _OptionsModal._(this.broadcast) : super(key: null);
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(imageUrl: broadcast.imageUrl),
          Spaces.verticalSmall,
          _Title(title: broadcast.title),
          Spaces.verticalMicro,
          _Creator(name: broadcast.effectiveCreatorName),
          Spaces.verticalXLarge,
          MModalListTile(
            leading: const Icon(MIcons.user),
            title: 'Go to Profile',
            onTap: () {
              // TODO(gettoknowdavid): Handle navigation to user's profile
            },
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: const Icon(MIcons.user_minus_01),
            title: 'Unsubscribe',
            onTap: () {
              // TODO(gettoknowdavid): Handle unsubscribe
            },
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: const Icon(MIcons.access_time),
            title: 'Listen Later',
            onTap: () {
              // TODO(gettoknowdavid): Handle listen later
            },
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: const Icon(MIcons.share),
            title: 'Share',
            onTap: () {
              // TODO(gettoknowdavid): Handle share
            },
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: const Icon(MIcons.link_02),
            title: 'Copy Link',
            onTap: () {
              // TODO(gettoknowdavid): Handle share link
            },
          ),
          Spaces.verticalXLarge,
        ],
      ),
    );
  }

  static Future<dynamic> show(BuildContext context, Broadcast broadcast) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => _OptionsModal._(broadcast),
    );
  }
}
