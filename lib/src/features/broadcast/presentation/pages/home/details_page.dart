import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../shared/helpers/date_helpers.dart';
import '../../../domain/domain.dart';

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
          MCore.large.horizontalSpace,
          MIconButton(
            icon: const Icon(MIcons.dots_horizontal),
            onPressed: () => context.showModal(
              DetailsPageOptionsModal(broadcast: broadcast),
              isScrollControlled: true,
            ),
          ),
          MCore.large.horizontalSpace,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MCore.large.verticalSpace,
            Align(
              alignment: Alignment.center,
              child: _Artwork(imageUrl: broadcast.imageUrl),
            ),
            MCore.small.verticalSpace,
            _Time(endTime: broadcast.endTime, startTime: broadcast.startTime),
            MCore.micro.verticalSpace,
            _Title(title: broadcast.title.getOr()),
            MCore.micro.verticalSpace,
            _Creator(name: broadcast.fullName!),
            MCore.large.verticalSpace,
            MPrimaryButton.icon(
              label: 'Restream',
              icon: const Icon(MIcons.play_arrow),
              onPressed: () {},
            ),
            40.verticalSpace,
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
    final colorScheme = MColorScheme.of(context)!;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(imageUrl: broadcast.imageUrl),
          MCore.small.verticalSpace,
          _Title(title: broadcast.title.getOr()),
          MCore.micro.verticalSpace,
          MText(
            broadcast.fullName!,
            style: MTextStyle.captionRegular,
            color: colorScheme.onBackgroundVariant,
          ),
          24.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.user),
            title: 'Go to Profile',
          ),
          MCore.small.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.user_minus_01),
            title: 'Unsubscribe',
          ),
          MCore.small.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.access_time),
            title: 'Listen Later',
          ),
          MCore.small.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          MCore.small.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  final String? imageUrl;
  const _Artwork({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final colorFilter = ColorFilter.mode(
      colorScheme.onSurfaceShade!,
      BlendMode.srcIn,
    );

    Widget image = Center(
      child: Assets.images.logoLight.svg(
        colorFilter: colorFilter,
        height: 32.0.h,
      ),
    );

    if (imageUrl != null) {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16).r,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => MShimmer(borderRadius: 16.r),
      );
    }

    return Container(
      width: 201.w,
      height: 128.h,
      decoration: BoxDecoration(
        color: colorScheme.surfaceShade,
        borderRadius: BorderRadius.circular(16).r,
      ),
      child: image,
    );
  }
}

class _Creator extends StatelessWidget {
  final String name;
  const _Creator({required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return SizedBox(
      height: 16.h,
      child: MTextButton.icon(
        label: name,
        icon: const Icon(MIcons.chevron_right),
        iconPlacement: MButtonIconPlacement.right,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: colorScheme.onBackgroundVariant,
          iconColor: colorScheme.onBackgroundVariant,
        ),
        onPressed: () {},
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String? description;
  const _Description({this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MIcons.menu_03, size: 16.r),
            MCore.small.horizontalSpace,
            const MText('About Broadcast', style: MTextStyle.subheadingMedium),
          ],
        ),
        MCore.large.verticalSpace,
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
  final DateTime? startTime;
  final DateTime? endTime;
  const _Time({this.startTime, this.endTime});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (endTime != null)
          MText(
            DateHelpers.calculateTimeAgo(endTime!),
            style: MTextStyle.captionRegular,
            color: colorScheme.onBackgroundVariant,
          ),
        if (startTime != null && endTime != null) ...[
          MCore.small.horizontalSpace,
          const MDot(),
          MCore.small.horizontalSpace,
          MText(
            DateHelpers.getTotalBroadcastTime(
              startTime: startTime!,
              endTime: endTime!,
            ),
            style: MTextStyle.captionRegular,
            color: colorScheme.onBackgroundVariant,
          ),
        ],
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: MText(
        title,
        style: MTextStyle.subheadingMedium,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
