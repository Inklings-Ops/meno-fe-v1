import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A custom widget that displays a circular avatar with optional border and
/// background image, file, or child widget.
///
/// The [MAvatar] widget can display an avatar with an image from a network URL,
/// a local file, or a placeholder widget. It also supports tap interactions and
/// customizable border visibility.
///
/// Example usage:
/// ```dart
/// MAvatar(
///   radius: 30.0,
///   url: 'https://example.com/avatar.png',
///   onTap: () {
///     print('Avatar tapped!');
///   },
/// )
/// ```
class MAvatar extends StatelessWidget {
  /// Creates an [MAvatar] widget.
  ///
  /// The [radius] parameter is required and specifies the radius of the avatar.
  /// The [key] parameter can be used to uniquely identify this widget in the
  /// widget tree.
  /// The [url] parameter specifies the URL for the background image of the
  /// avatar.
  /// The [file] parameter specifies the local file for the background image of
  /// the avatar.
  /// The [child] parameter specifies a widget to display in the center of the
  /// avatar.
  /// The [onTap] parameter specifies a callback function to be called when the
  /// avatar is tapped.
  /// The [hasBorder] parameter specifies whether the avatar should have a
  /// border around it. It defaults to true.
  /// The [loading] parameter specifies whether the avatar url is being loaded.
  const MAvatar({
    required this.radius,
    super.key,
    this.url,
    this.file,
    this.child,
    this.onTap,
    this.hasBorder = true,
    this.loading = false,
  });

  /// The radius of the avatar.
  ///
  /// This determines the size of the circular avatar.
  final double radius;

  /// The URL of the background image for the avatar.
  ///
  /// If provided, this URL will be used to fetch and display an image in the
  /// avatar.
  final String? url;

  /// The local file for the background image of the avatar.
  ///
  /// If provided, this file will be used to display a local image in the
  /// avatar.
  final File? file;

  /// A widget to display in the center of the avatar.
  ///
  /// This widget is displayed on top of the background image or color of the
  /// avatar.
  final Widget? child;

  /// A callback function to be called when the avatar is tapped.
  ///
  /// If provided, this function will be invoked when the user taps on the
  /// avatar.
  final VoidCallback? onTap;

  /// Whether the avatar should have a border around it.
  ///
  /// If true, a border will be added around the avatar. Defaults to true.
  final bool hasBorder;

  /// Flag for when the image is being loaded from the url
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final hasUrl = url != null;
    final hasFile = file != null;

    ImageProvider<Object>? backgroundImage;
    ImageProvider<Object>? foregroundImage;
    Widget? placeholder;

    if (loading) {
      foregroundImage = null;
      backgroundImage = null;
      placeholder = null;
    }

    if (!hasFile && !hasUrl && !loading) {
      placeholder = child ?? Center(child: MPlaceholder(dimension: radius));
    }

    if (hasUrl && !hasFile && !loading) {
      foregroundImage = CachedNetworkImageProvider(
        url!,
        maxHeight: 512,
        maxWidth: 512,
      );
    }

    if (hasFile && !loading) {
      backgroundImage = FileImage(file!);
    }

    final Widget avatar = CircleAvatar(
      radius: radius,
      foregroundImage: foregroundImage,
      backgroundImage: backgroundImage,
      backgroundColor: colors.surfaceShade,
      child: placeholder,
    );

    return Skeleton.leaf(
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: colors.outlineVariant3,
          child: Padding(
            padding: hasBorder ? const EdgeInsets.all(1.50) : EdgeInsets.zero,
            child: avatar,
          ),
        ),
      ),
    );
  }
}
