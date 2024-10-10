import 'package:cached_network_image/cached_network_image.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';


class DetailsPage extends StatelessWidget {
  const DetailsPage({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(
        title: broadcast.title.getOr(),
        actions: [
          const MIconButton(icon: Icon(MIcons.star_border)),
          Spaces.horizontalLarge,
          MIconButton(
            icon: const Icon(MIcons.dots_horizontal),
            onPressed: () => context.showModal<void>(
              DetailsPageOptionsModal(broadcast: broadcast),
              isScrollControlled: true,
            ),
          ),
          Spaces.horizontalLarge,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Spaces.verticalLarge,
            Align(
              child: _Artwork(imageUrl: broadcast.imageUrl),
            ),
            Spaces.verticalSmall,
            _Time(endTime: broadcast.endTime, startTime: broadcast.startTime),
            Spaces.verticalMicro,
            _Title(title: broadcast.title.getOr()),
            Spaces.verticalMicro,
            _Creator(name: broadcast.fullName!),
            Spaces.verticalLarge,
            MPrimaryButton.icon(
              label: 'Restream',
              icon: const Icon(MIcons.play_arrow),
              onPressed: () {},
            ),
            const SizedBox(height: 40),
            _Description(description: broadcast.description?.getOr()),
          ],
        ),
      ),
    );
  }
}

class DetailsPageOptionsModal extends StatelessWidget {
  const DetailsPageOptionsModal({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(imageUrl: broadcast.imageUrl),
          Spaces.verticalSmall,
          _Title(title: broadcast.title.getOr()),
          Spaces.verticalMicro,
          MText(
            broadcast.fullName!,
            style: textTheme.captionRegular,
            color: colors.onBackgroundVariant,
          ),
          Spaces.verticalXLarge,
          const MModalListTile(
            leading: Icon(MIcons.user),
            title: 'Go to Profile',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.user_minus_01),
            title: 'Unsubscribe',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.access_time),
            title: 'Listen Later',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          Spaces.verticalXLarge,
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
    const borderRadius = Corners.lg;

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade!,
      BlendMode.srcIn,
    );

    Widget image = Center(
      child: Assets.images.logoLight.svg(
        colorFilter: colorFilter,
        height: 32,
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

class _Creator extends StatelessWidget {
  const _Creator({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      height: 16,
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
    final textTheme = MTextTheme.of(context)!;
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
    final textTheme = MTextTheme.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (endTime != null)
          MText(
            DateHelpers.calculateTimeAgo(endTime!),
            style: textTheme.captionRegular,
            color: colors.onBackgroundVariant,
          ),
        if (startTime != null && endTime != null) ...[
          Spaces.horizontalSmall,
          const MDot(),
          Spaces.horizontalSmall,
          MText(
            DateHelpers.getTotalBroadcastTime(
              startTime: startTime!,
              endTime: endTime!,
            ),
            style: textTheme.captionRegular,
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
    final textTheme = MTextTheme.of(context)!;
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
