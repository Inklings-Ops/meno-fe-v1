import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MAvatar extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  final bool isArtwork;
  final Widget? child;

  const MAvatar({
    super.key,
    required this.radius,
    this.url,
    this.file,
    this.isArtwork = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    final bool hasUrl = url != null;
    final bool hasFile = file != null;

    ImageProvider<Object>? backgroundImage;
    ImageProvider<Object>? foregroundImage;
    Widget? placeholder;

    final int maxHeight = (radius * 2).toInt();

    final SizedBox artwork = SizedBox(
      height: radius * 0.7,
      child: colorScheme.brightness == Brightness.light
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );

    final Icon icon = Icon(
      MIcons.user_circle,
      size: radius,
      color: colorScheme.onInversePrimary,
    );

    if (!hasFile && !hasUrl) {
      placeholder = child ?? Center(child: isArtwork ? artwork : icon);
    }

    if (hasUrl && !hasFile) {
      foregroundImage = CachedNetworkImageProvider(
        url!,
        maxHeight: maxHeight,
        maxWidth: maxHeight,
      );
    }

    if (hasFile) {
      backgroundImage = FileImage(file!);
    }

    return CircleAvatar(
      radius: radius,
      foregroundImage: foregroundImage,
      backgroundImage: backgroundImage,
      backgroundColor: colorScheme.surfaceShade,
      child: placeholder,
    );
  }
}
