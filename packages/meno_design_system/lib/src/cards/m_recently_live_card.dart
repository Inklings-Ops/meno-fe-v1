import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';

class MRecentlyLiveCard extends StatelessWidget {
  final String title;
  final String host;
  final String? imageUrl;
  final VoidCallback? onTap;

  const MRecentlyLiveCard({
    super.key,
    required this.title,
    required this.host,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final MCardStyles styles = MCardStyles.of(context)!;

    final bool isLight = Theme.of(context).brightness == Brightness.light;

    final ColorFilter colorFilter = ColorFilter.mode(
      isLight ? MColor.grey200 : MColor.grey30,
      BlendMode.srcIn,
    );

    final bool hasImage = imageUrl != null;

    final SvgPicture placeholder = Assets.images.logoLight.svg(
      colorFilter: colorFilter,
      height: 32.0,
    );

    final DecorationImage? image = hasImage
        ? DecorationImage(
            image: CachedNetworkImageProvider(imageUrl!), fit: BoxFit.cover)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: _Container(
        children: [
          Container(
            width: 148,
            height: 88,
            padding: const EdgeInsets.symmetric(vertical: 28),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isLight ? MColor.grey30 : MColor.grey400,
              borderRadius: BorderRadius.circular(12),
              image: image,
            ),
            child: !hasImage ? placeholder : null,
          ),
          MSize.verticalSpaceMedium,
          MText(
            title,
            style: styles.titleStyle,
            color: styles.titleColor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          MSize.verticalSpaceMicro,
          MText(
            host,
            style: styles.hostStyle,
            color: styles.hostColor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class MRecentlyLiveCardSkeleton extends StatelessWidget {
  const MRecentlyLiveCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Container(
      children: [
        MShimmer(borderRadius: 12, width: 148, height: 88),
        MSize.verticalSpaceMedium,
        MShimmer(height: 24),
        MSize.verticalSpaceMicro,
        MShimmer(height: 14, width: 80),
      ],
    );
  }
}

class _Container extends StatelessWidget {
  final List<Widget> children;
  const _Container({required this.children});

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;

    return Container(
      width: 176,
      height: 176,
      padding: const EdgeInsets.all(14.0),
      decoration: ShapeDecoration(
        color: styles.backgroundColor,
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 16, cornerSmoothing: 1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
