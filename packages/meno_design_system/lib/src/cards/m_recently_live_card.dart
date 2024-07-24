import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

class MRecentlyLiveCard extends StatelessWidget {
  const MRecentlyLiveCard({
    super.key,
    required this.title,
    required this.host,
    this.imageUrl,
    this.onTap,
  });
  final String title;
  final String host;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final colorFilter = ColorFilter.mode(
      isLight ? MColor.grey200 : MColor.grey30,
      BlendMode.srcIn,
    );

    final hasImage = imageUrl != null;

    final placeholder = Assets.images.logoLight.svg(
      colorFilter: colorFilter,
      height: 32.0.toScale,
    );

    final DecorationImage? image = hasImage
        ? DecorationImage(
            image: CachedNetworkImageProvider(imageUrl!),
            fit: BoxFit.cover,
          )
        : null;

    return GestureDetector(
      onTap: onTap,
      child: _Container(
        children: [
          Container(
            width: 148.toScale,
            height: 88.toScale,
            padding: const EdgeInsets.symmetric(vertical: 28).radius,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isLight ? MColor.grey30 : MColor.grey400,
              borderRadius: $styles.radius.medium,
              image: image,
            ),
            child: !hasImage ? placeholder : null,
          ),
          $styles.spaces.verticalMedium,
          MText(
            title,
            style: styles.titleStyle,
            color: styles.titleColor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          $styles.spaces.verticalMicro,
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
    return _Container(
      children: [
        const MShimmer(borderRadius: 12, width: 148, height: 88),
        $styles.spaces.verticalMedium,
        const MShimmer(height: 24),
        $styles.spaces.verticalMicro,
        const MShimmer(height: 14, width: 80),
      ],
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    return Container(
      width: 176.toScale,
      height: 176.toScale,
      padding: const EdgeInsets.all(14.0).radius,
      decoration: ShapeDecoration(
        color: styles.backgroundColor,
        shadows: $styles.shadows.soft,
        shape: SmoothRectangleBorder(
          borderRadius: $styles.radius.squircleLarge,
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
