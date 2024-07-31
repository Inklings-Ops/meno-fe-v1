import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A widget that represents a card for recently live content.
///
/// This card displays information about recently live content, including the
/// title of the content, the host, and an optional image. The card can also
/// handle tap gestures through the [onTap] callback.
///
/// Example usage:
/// ```dart
/// MRecentlyLiveCard(
///   title: 'Live Event Title',
///   host: 'Host Name',
///   imageUrl: 'https://example.com/image.jpg',
///   onTap: () {
///     // Handle card tap
///   },
/// );
/// ```
class MRecentlyLiveCard extends StatelessWidget {
  /// Creates an instance of [MRecentlyLiveCard].
  ///
  /// Parameters:
  /// - [title]: The title of the recently live content.
  /// - [host]: The name of the host of the recently live content.
  /// - [loading]: A boolean indicating if the card is in a loading state.
  /// - [key]: An optional key to identify the widget.
  /// - [imageUrl]: An optional URL for an image to be displayed in the card.
  /// - [onTap]: An optional callback function to be invoked when the card is
  /// tapped.
  const MRecentlyLiveCard({
    required this.loading,
    this.title,
    this.host,
    super.key,
    this.imageUrl,
    this.onTap,
  });

  /// The title of the recently live content.
  final String? title;

  /// The name of the host of the recently live content.
  final String? host;

  /// The URL of an image to be displayed in the card.
  final String? imageUrl;

  /// A callback function to be invoked when the card is tapped.
  final VoidCallback? onTap;

  /// A boolean indicating if the card is in a loading state.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final colorFilter = ColorFilter.mode(
      isLight ? MColor.grey200 : MColor.grey30,
      BlendMode.srcIn,
    );

    final hasImage = imageUrl != null;

    Widget? placeholder;

    DecorationImage? image;
    if (loading) {
      image = null;
      placeholder = null;
    } else {
      if (hasImage) {
        image = DecorationImage(
          image: CachedNetworkImageProvider(imageUrl!),
          fit: BoxFit.cover,
        );
      } else {
        placeholder = Assets.images.logoLight.svg(
          colorFilter: colorFilter,
          height: 32,
        );
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: _Container(
        children: [
          Skeletonizer(
            enabled: loading,
            containersColor: isLight ? MColor.grey30 : MColor.grey400,
            child: Container(
              width: 148,
              height: 88,
              padding: const EdgeInsets.symmetric(vertical: 28),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isLight ? MColor.grey30 : MColor.grey400,
                borderRadius: Corners.medium,
                image: loading ? null : image,
              ),
              child: !hasImage ? placeholder : null,
            ),
          ),
          Spaces.verticalMedium,
          Skeletonizer(
            enabled: loading,
            child: MText(
              loading ? BoneMock.fullName : title!,
              style: styles.titleStyle,
              color: styles.titleColor,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spaces.verticalMicro,
          Skeletonizer(
            enabled: loading,
            child: MText(
              loading ? BoneMock.name : host!,
              style: styles.hostStyle,
              color: styles.hostColor,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
      width: 176,
      height: 176,
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: styles.backgroundColor,
        shadows: Shadows.soft,
        shape: SmoothRectangleBorder(
          borderRadius: Corners.squircleLarge,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
