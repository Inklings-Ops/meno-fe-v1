import 'package:cached_network_image/cached_network_image.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class DetailsPage extends StatelessWidget {
  final Broadcast broadcast;
  const DetailsPage({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(
        title: broadcast.title.getOr(),
        actions: [
          const MIconButton(icon: Icon(MIcons.star_border)),
          $styles.spaces.horizontalLarge,
          MIconButton(
            icon: const Icon(MIcons.dots_horizontal),
            onPressed: () => context.showModal(
              DetailsPageOptionsModal(broadcast: broadcast),
              isScrollControlled: true,
            ),
          ),
          $styles.spaces.horizontalLarge,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            $styles.spaces.verticalLarge,
            Align(
              alignment: Alignment.center,
              child: _Artwork(imageUrl: broadcast.imageUrl),
            ),
            $styles.spaces.verticalSmall,
            _Time(endTime: broadcast.endTime, startTime: broadcast.startTime),
            $styles.spaces.verticalMicro,
            _Title(title: broadcast.title.getOr()),
            $styles.spaces.verticalMicro,
            _Creator(name: broadcast.fullName!),
            $styles.spaces.verticalLarge,
            MPrimaryButton.icon(
              label: 'Restream',
              icon: const Icon(MIcons.play_arrow),
              onPressed: () {},
            ),
            40.vSpace,
            _Description(description: broadcast.description?.getOr()),
          ],
        ),
      ),
    );
  }
}

class DetailsPageOptionsModal extends StatelessWidget {
  final Broadcast broadcast;
  const DetailsPageOptionsModal({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(imageUrl: broadcast.imageUrl),
          $styles.spaces.verticalSmall,
          _Title(title: broadcast.title.getOr()),
          $styles.spaces.verticalMicro,
          MText(
            broadcast.fullName!,
            style: $styles.text.captionRegular,
            color: colors.onBackgroundVariant,
          ),
          24.vSpace,
          const MModalListTile(
            leading: Icon(MIcons.user),
            title: 'Go to Profile',
          ),
          $styles.spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.user_minus_01),
            title: 'Unsubscribe',
          ),
          $styles.spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.access_time),
            title: 'Listen Later',
          ),
          $styles.spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          $styles.spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          24.vSpace,
        ],
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final borderRadius = $styles.radius.large;

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade!,
      BlendMode.srcIn,
    );

    Widget image = Center(
      child: Assets.images.logoLight.svg(
        colorFilter: colorFilter,
        height: 32.0.toScale,
      ),
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
      width: 201.toScale,
      height: 128.toScale,
      decoration: BoxDecoration(
        color: colors.surfaceShade,
        borderRadius: borderRadius,
      ),
      child: image,
    );
  }
}

class _Creator extends StatelessWidget {
  const _Creator({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      height: 16.toScale,
      child: MTextButton.icon(
        label: name,
        icon: const Icon(MIcons.chevron_right),
        iconPlacement: MButtonIconPlacement.right,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: colors.onBackgroundVariant,
          iconColor: colors.onBackgroundVariant,
        ),
        onPressed: () {},
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({this.description});
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MIcons.menu_03, size: 16.toScale),
            $styles.spaces.horizontalSmall,
            MText('About Broadcast', style: $styles.text.subheadingMedium),
          ],
        ),
        $styles.spaces.verticalLarge,
        if (description != null)
          Align(
            alignment: Alignment.centerLeft,
            child: MText(description!),
          ),
      ],
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({this.startTime, this.endTime});
  final DateTime? startTime;
  final DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (endTime != null)
          MText(
            DateHelpers.calculateTimeAgo(endTime!),
            style: $styles.text.captionRegular,
            color: colors.onBackgroundVariant,
          ),
        if (startTime != null && endTime != null) ...[
          $styles.spaces.horizontalSmall,
          const MDot(),
          $styles.spaces.horizontalSmall,
          MText(
            DateHelpers.getTotalBroadcastTime(
              startTime: startTime!,
              endTime: endTime!,
            ),
            style: $styles.text.captionRegular,
            color: colors.onBackgroundVariant,
          ),
        ],
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.toScale,
      child: MText(
        title,
        style: $styles.text.subheadingMedium,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
