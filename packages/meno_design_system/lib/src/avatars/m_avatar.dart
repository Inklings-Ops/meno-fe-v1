import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

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
    final theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final Color color = MInternal.resolve(
      isLight,
      MColor.grey20,
      MColor.primaryAlt,
    );

    final bool hasUrl = url != null;
    final bool hasFile = file != null;

    ImageProvider<Object>? backgroundImage;
    ImageProvider<Object>? foregroundImage;
    Widget? placeholder;

    final SizedBox artwork = SizedBox(
      height: radius * 0.7,
      child: isLight
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );

    final Icon icon = Icon(
      MIcons.user_circle,
      size: radius,
      color: isLight ? MColor.primary700 : MColor.white,
    );

    if (!hasFile && !hasUrl) {
      placeholder = child ?? Center(child: isArtwork ? artwork : icon);
    }

    if (hasUrl && !hasFile) {
      foregroundImage = CachedNetworkImageProvider(url!);
    }

    if (hasFile) {
      backgroundImage = FileImage(file!);
    }

    return CircleAvatar(
      radius: radius,
      foregroundImage: foregroundImage,
      backgroundImage: backgroundImage,
      backgroundColor: color,
      child: placeholder,
    );
  }
}
