import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';

class MRecentlyLiveListTile extends StatelessWidget {
  final String? title;
  final DateTime? endTime;
  final String? creator;
  final String? imageUrl;
  final bool loading;
  final VoidCallback? onTap;

  const MRecentlyLiveListTile({
    super.key,
    this.title,
    this.endTime,
    this.creator,
    this.imageUrl,
    this.loading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final ColorFilter colorFilter = ColorFilter.mode(
      colorScheme.onSurfaceShade!,
      BlendMode.srcIn,
    );

    if (loading) {
      return const _Skeleton();
    }

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant1!, width: 1),
      ),
      minLeadingWidth: 12,
      leading: SizedBox(
        width: 79,
        height: 68,
        child: imageUrl == null
            ? Center(
                child: Assets.images.logoLight.svg(
                  colorFilter: colorFilter,
                  height: 32.0,
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                imageBuilder: (context, imageProvider) => DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
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
            style: MTextStyle.captionRegular,
            color: colorScheme.onBackgroundVariant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          MSize.verticalSpaceMicro,
          MText(
            title!,
            style: MTextStyle.captionMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          MSize.verticalSpaceMicro,
          MText(
            creator!,
            style: MTextStyle.captionRegular,
            color: colorScheme.onBackgroundVariant,
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
    final colorScheme = MColorScheme.of(context)!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant1!, width: 1),
      ),
      minLeadingWidth: 12,
      leading: const MShimmer(borderRadius: 12, width: 79, height: 68),
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MShimmer(height: 14, width: 70),
          MSize.verticalSpaceMicro,
          MShimmer(height: 24),
          MSize.verticalSpaceMicro,
          MShimmer(height: 14, width: 150),
        ],
      ),
    );
  }
}
