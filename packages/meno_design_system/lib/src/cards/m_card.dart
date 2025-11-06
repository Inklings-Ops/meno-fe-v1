import 'package:flutter/material.dart';
import 'package:meno_design_system/src/cards/cards.dart';

/// A base class for styled cards with different types of content.
///
/// This class provides factory constructors for creating specific types of
/// cards, such as live cards and recently live cards. It uses the
/// [MBaseCard] as a base class for styling and functionality.
///
/// To create a live card or a recently live card, use the [MCard.live] or
/// [MCard.recentlyLive] factory methods.
///
/// Example usage:
/// ```dart
/// MCard.live(
///   title: 'Live Event Title',
///   host: 'Host Name',
///   imageUrl: 'https://example.com/image.jpg',
///   liveCount: 1234,
///   onTap: () {
///     // Handle card tap
///   },
/// );
/// ```
class MCard extends MBaseCard {
  /// Factory constructor for creating a live card.
  ///
  /// Parameters:
  /// - [key]: An optional key to identify the widget.
  /// - [title]: The title of the live content.
  /// - [host]: The name of the host of the live content.
  /// - [imageUrl]: An optional URL for an image to be displayed in the card.
  /// - [liveCount]: An optional count of live viewers or participants.
  /// - [onTap]: An optional callback function to be invoked when the card is
  /// tapped.
  factory MCard.live({
    Key? key,
    String? title,
    String? host,
    String? imageUrl,
    int? liveCount,
    VoidCallback? onTap,
  }) = _LiveCard;

  /// Factory constructor for creating a recently live card.
  ///
  /// Parameters:
  /// - [key]: An optional key to identify the widget.
  /// - [title]: The title of the recently live content.
  /// - [host]: An optional name of the host of the recently live content.
  /// - [imageUrl]: An optional URL for an image to be displayed in the card.
  /// - [onTap]: An optional callback function to be invoked when the card is
  /// tapped.
  factory MCard.recentlyLive({
    Key? key,
    String? title,
    String? host,
    String? imageUrl,
    VoidCallback? onTap,
  }) = _RecentlyLiveCard;

  const MCard._({
    required super.child,
    required super.title,
    super.key,
    super.subtitle,
    super.onTap,
  });
}

class _LiveCard extends MCard {
  _LiveCard({
    super.key,
    super.title,
    String? host,
    String? imageUrl,
    int? liveCount,
    super.onTap,
  }) : super._(
         child: MLiveCard(
           title: title,
           host: host,
           imageUrl: imageUrl,
           liveCount: liveCount,
           onTap: onTap,
         ),
       );
}

class _RecentlyLiveCard extends MCard {
  _RecentlyLiveCard({
    super.key,
    super.title,
    String? host,
    String? imageUrl,
    VoidCallback? onTap,
  }) : super._(
         child: MRecentlyLiveCard(
           title: title,
           host: host,
           imageUrl: imageUrl,
           onTap: onTap,
         ),
       );
}
