import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:shimmer/shimmer.dart';

class MShimmer extends StatelessWidget {
  final bool enabled;
  final Widget? child;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxShape shape;

  const MShimmer({
    super.key,
    this.enabled = true,
    this.child,
    this.backgroundColor,
    this.height,
    this.width,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final bool isCircle = shape == BoxShape.circle;

    return Shimmer.fromColors(
      enabled: enabled,
      baseColor: colorScheme.background!,
      highlightColor: colorScheme.surfaceShade!,
      child: Container(
        decoration: BoxDecoration(
          shape: shape,
          color: backgroundColor ?? colorScheme.background,
          borderRadius:
              isCircle ? null : BorderRadius.circular(borderRadius ?? 4),
        ),
        child: child ??
            Container(
              height: height,
              width: width ?? double.infinity,
              decoration: BoxDecoration(
                shape: shape,
                color: backgroundColor ?? colorScheme.background,
                borderRadius:
                    isCircle ? null : BorderRadius.circular(borderRadius ?? 4),
              ),
            ),
      ),
    );
  }
}
