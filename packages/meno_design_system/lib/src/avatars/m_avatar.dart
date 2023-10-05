import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

class MAvatar extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  const MAvatar({super.key, required this.radius, this.url, this.file});

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

    if (!hasFile && !hasUrl) {
      placeholder = Center(
        child: Icon(
          MIcons.user_circle,
          size: radius,
          color: isLight ? MColor.primary700 : MColor.white,
        ),
      );
    }

    if (hasUrl && !hasFile) {
      foregroundImage = NetworkImage(url!);
    }

    if (hasFile) {
      backgroundImage = AssetImage(file!.path);
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
