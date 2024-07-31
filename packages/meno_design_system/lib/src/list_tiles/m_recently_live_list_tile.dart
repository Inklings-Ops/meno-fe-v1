import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';
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
  /// - [loading]: A boolean indicating whether the loading state is active.
  /// Defaults to false.
  /// - [onTap]: A callback function to handle tap events.
  const MRecentlyLiveListTile({
    super.key,
    this.title,
    this.endTime,
    this.creator,
    this.imageUrl,
    this.loading = false,
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

  /// A boolean indicating whether the loading state is active.
  /// Defaults to false.
  final bool loading;

  /// A callback function to handle tap events.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      shape: SmoothRectangleBorder(
        side: BorderSide(color: colors.outlineVariant1!),
        borderRadius: Corners.squircleLarge,
      ),
      minLeadingWidth: 12,
      leading: _Artwork(imageUrl: imageUrl, loading: loading),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeletonizer(
            enabled: loading,
            child: MText(
              loading
                  ? BoneMock.date
                  : endTime?.toIso8601String() ?? 'A while back',
              style: textTheme.captionRegular,
              color: colors.onBackgroundVariant,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spaces.verticalMicro,
          Skeletonizer(
            enabled: loading,
            child: MText(
              loading ? BoneMock.name : title!,
              style: textTheme.captionMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spaces.verticalMicro,
          Skeletonizer(
            enabled: loading,
            child: MText(
              loading ? BoneMock.name : creator!,
              style: textTheme.captionRegular,
              color: colors.onBackgroundVariant,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({this.imageUrl, this.loading = false});
  final String? imageUrl;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final colorFilter = ColorFilter.mode(
      colors.onSurfaceShade!,
      BlendMode.srcIn,
    );
    Widget? imageWidget;

    if (imageUrl == null) {
      imageWidget = Center(
        child: Assets.images.logoLight.svg(
          colorFilter: colorFilter,
          height: 32,
        ),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) => Skeletonizer(
          child: Container(
            width: 79,
            height: 68,
            decoration: const BoxDecoration(borderRadius: Corners.medium),
          ),
        ),
        imageBuilder: (context, image) => DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover),
            borderRadius: Corners.medium,
          ),
        ),
      );
    }

    return Skeletonizer(
      enabled: loading,
      child: Container(
        width: 79,
        height: 68,
        color: colors.background,
        child: loading ? null : imageWidget,
      ),
    );
  }
}
