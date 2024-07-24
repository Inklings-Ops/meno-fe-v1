import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

class MPlaceholder extends StatelessWidget {
  const MPlaceholder({super.key, this.dimension});
  final double? dimension;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return SizedBox.square(
      dimension: dimension?.toScale,
      child: isLight
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );
  }
}
