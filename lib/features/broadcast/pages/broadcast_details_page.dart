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
            http: di<BroadcastHttpService>(),
            currentUserId: di<UserManager>().currentUserId.value,
            broadcastId: Id.fromString(broadcastIdStr),
          );
          await manager.fetch.runAsync();
          return manager;
        });
      },
    );

    final isFetching = watchValue((_Manager m) => m.fetch.isRunning);
    final proxy = watchValue((_Manager m) => m.proxy);
    final error = watchValue((_Manager m) => m.fetch.errors);

    if (isFetching) {
      return Skeletonizer(
        child: BroadcastDetailsView(
          proxy: BroadcastProxy(fakeLiveBroadcast, Id.empty),
        ),
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

    if (proxy == null) {
      return MScaffold(
        appBar: MAppBar.secondary(title: 'Not Found'),
        body: MenoErrorWidget(
          message: 'No broadcast found. Please try again.',
          onRetry: di<_Manager>().fetch.runAsync,
        ),
      );
    }

    return BroadcastDetailsView(proxy: proxy);
  }
}

class BroadcastDetailsView extends WatchingWidget {
  const BroadcastDetailsView({required this.proxy, super.key});

  final BroadcastProxy proxy;

  @override
  Widget build(BuildContext context) {
    watch(proxy);

    return MScaffold(
      appBar: MAppBar.secondary(
        title: proxy.title,
        actions: [
          MIconButton(
            icon: proxy.isFavourited
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border),
            onPressed: proxy.toggleIsFavourite.run,
          ),
          Spaces.horizontalLarge,
          MIconButton(
            icon: const Icon(MIcons.dots_horizontal),
            onPressed: () => _OptionsModal.show(context, proxy.broadcast),
          ),
          Spaces.horizontalLarge,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Spaces.verticalLarge,
            Align(child: _Artwork(imageUrl: proxy.imageUrl)),
            Spaces.verticalSmall,
            _Title(title: proxy.title),
            Spaces.verticalMicro,
            _Creator(
              name: proxy.creatorName,
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
            _Description(description: proxy.description),
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

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return SizedBox(
      height: 24,
      child: MText(
        title,
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

  final String name;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return SizedBox(
      height: 16,
      child: MTextButton.icon(
        label: name,
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

  final String? description;

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
        Align(alignment: .centerLeft, child: MText(description!)),
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
          _Title(title: broadcast.title.getOrCrash()),
          Spaces.verticalMicro,
          _Creator(name: broadcast.hostName.getOrCrash()),
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
