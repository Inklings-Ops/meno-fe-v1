import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MAvatar extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  final Widget? child;
  final VoidCallback? onTap;
  final bool hasBorder;

  const MAvatar({
    super.key,
    required this.radius,
    this.url,
    this.file,
    this.child,
    this.onTap,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final bool hasUrl = url != null;
    final bool hasFile = file != null;

    ImageProvider<Object>? backgroundImage;
    ImageProvider<Object>? foregroundImage;
    Widget? placeholder;

    if (!hasFile && !hasUrl) {
      placeholder = child ?? Center(child: MPlaceholder(dimension: radius));
    }

    if (hasUrl && !hasFile) {
      foregroundImage = CachedNetworkImageProvider(
        url!,
        maxHeight: 512,
        maxWidth: 512,
      );
    }

    if (hasFile) {
      backgroundImage = FileImage(file!);
    }

    Widget avatar = CircleAvatar(
      radius: radius,
      foregroundImage: foregroundImage,
      backgroundImage: backgroundImage,
      backgroundColor: colorScheme.surfaceShade,
      child: placeholder,
    );

    return GestureDetector(
      onTap: onTap,
      child: !hasBorder
          ? avatar
          : CircleAvatar(
              radius: radius,
              backgroundColor: colorScheme.outlineVariant3,
              child: Padding(
                padding: const EdgeInsets.all(1.50),
                child: avatar,
              ),
            ),
    );
  }
}
