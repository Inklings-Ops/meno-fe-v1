import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

class MRecentlyLiveListTile extends StatelessWidget {
  const MRecentlyLiveListTile({
    super.key,
    this.title,
    this.endTime,
    this.creator,
    this.imageUrl,
    this.loading = false,
    this.onTap,
  });
  final String? title;
  final DateTime? endTime;
  final String? creator;
  final String? imageUrl;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade!,
      BlendMode.srcIn,
    );

    if (loading) return const _Skeleton();

    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14).radius,
      shape: SmoothRectangleBorder(
        side: BorderSide(color: colors.outlineVariant1!, width: 1.toScale),
        borderRadius: $styles.radius.squircleLarge,
      ),
      minLeadingWidth: 12.toScale,
      leading: SizedBox(
        width: 79.toScale,
        height: 68.toScale,
        child: imageUrl == null
            ? Center(
                child: Assets.images.logoLight.svg(
                  colorFilter: colorFilter,
                  height: 32.0.toScale,
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                imageBuilder: (context, imageProvider) => DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: $styles.radius.medium,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const MShimmer(borderRadius: 12),
              ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MText(
            endTime?.toIso8601String() ?? "A while back",
            style: $styles.text.captionRegular,
            color: colors.onBackgroundVariant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          $styles.spaces.verticalMicro,
          MText(
            title!,
            style: $styles.text.captionMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          $styles.spaces.verticalMicro,
          MText(
            creator!,
            style: $styles.text.captionRegular,
            color: colors.onBackgroundVariant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14).radius,
      shape: SmoothRectangleBorder(
        side: BorderSide(color: colors.outlineVariant1!, width: 1.toScale),
        borderRadius: $styles.radius.squircleLarge,
      ),
      minLeadingWidth: 12.toScale,
      leading: const MShimmer(borderRadius: 12, width: 79, height: 68),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MShimmer(height: 14, width: 70),
          $styles.spaces.verticalMicro,
          const MShimmer(height: 24),
          $styles.spaces.verticalMicro,
          const MShimmer(height: 14, width: 150),
        ],
      ),
    );
  }
}
