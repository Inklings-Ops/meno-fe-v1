import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A widget that displays information about a recently live event.
///
/// This widget provides a tile layout for displaying details about a recently
/// live event, including the event title, end time, creator, and an optional
/// image. It also supports handling tap events and showing a loading state.
///
/// To use this widget, provide the necessary parameters such as the title,
/// end time, creator, and optional image URL. You can also specify whether the
/// tile is in a loading state
/// and provide a callback function for handling tap events.
///
/// Example usage:
/// ```dart
/// MRecentlyLiveListTile(
///   title: 'Live Concert',
///   endTime: DateTime.now(),
///   creator: 'John Doe',
///   imageUrl: 'https://example.com/image.jpg',
///   onTap: () {
///     // Handle tap event
///   },
/// );
/// ```
class MRecentlyLiveListTile extends StatelessWidget {
  /// Creates an instance of [MRecentlyLiveListTile].
  ///
  /// Parameters:
  /// - [key]: An optional key to identify the widget.
  /// - [title]: The title of the recently live event.
  /// - [endTime]: The end time of the recently live event.
  /// - [creator]: The creator of the recently live event.
  /// - [imageUrl]: An optional URL for the event image.
  /// Defaults to false.
  /// - [onTap]: A callback function to handle tap events.
  const MRecentlyLiveListTile({
    super.key,
    this.title,
    this.endTime,
    this.creator,
    this.imageUrl,
    this.onTap,
  });

  /// The title of the recently live event.
  final String? title;

  /// The end time of the recently live event.
  final DateTime? endTime;

  /// The creator of the recently live event.
  final String? creator;

  /// An optional URL for the event image.
  final String? imageUrl;

  /// A callback function to handle tap events.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ).r,
      shape: RoundedSuperellipseBorder(
        side: BorderSide(color: colors.outlineVariant1),
        borderRadius: Corners.lg.r,
      ),
      minLeadingWidth: 12.w,
      leading: _Artwork(imageUrl: imageUrl),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MText.caption(
            endTime != null ? GetTimeAgo.parse(endTime!) : 'A while back',
            color: colors.onBackgroundVariant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            weight: MFontWeight.regular,
          ),
          Spaces.verticalMicro,
          MText.caption(title!, maxLines: 1, overflow: TextOverflow.ellipsis),
          Spaces.verticalMicro,
          MText.caption(
            creator!,
            color: colors.onBackgroundVariant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            weight: MFontWeight.regular,
          ),
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
    final colors = MColorScheme.of(context);

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade,
      BlendMode.srcIn,
    );

    Widget? imageWidget;

    if (imageUrl == null) {
      imageWidget = Center(
        child: Assets.images.logoLight.svg(
          colorFilter: colorFilter,
          height: 32.h,
        ),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) => Container(
          width: 79.w,
          height: 68.h,
          decoration: BoxDecoration(borderRadius: Corners.md.r),
        ),
        imageBuilder: (context, image) => DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover),
            borderRadius: Corners.md.r,
          ),
        ),
      );
    }

    return Skeleton.leaf(
      child: Container(
        width: 79.w,
        height: 68.h,
        color: colors.background,
        child: imageWidget,
      ),
    );
  }
}
