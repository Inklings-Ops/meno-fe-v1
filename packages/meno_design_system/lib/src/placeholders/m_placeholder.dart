import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class MPlaceholder extends StatelessWidget {
  final double? dimension;
  const MPlaceholder({super.key, this.dimension});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SizedBox.square(
      dimension: dimension,
      child: isLight
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );
  }
}
