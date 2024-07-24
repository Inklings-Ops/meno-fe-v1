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
    final colors = MColorScheme.of(context)!;
    final isCircle = shape == BoxShape.circle;
    final effectiveBorderRadius =
        BorderRadius.circular(borderRadius ?? 4).radius;
    return Shimmer.fromColors(
      enabled: enabled,
      baseColor: colors.background!,
      highlightColor: colors.surfaceShade!,
      child: Container(
        decoration: BoxDecoration(
          shape: shape,
          color: backgroundColor ?? colors.background,
          borderRadius: isCircle ? null : effectiveBorderRadius,
        ),
        child: child ??
            Container(
              height: height?.toScale,
              width: width?.toScale ?? double.infinity,
              decoration: BoxDecoration(
                shape: shape,
                color: backgroundColor ?? colors.background,
                borderRadius: isCircle ? null : effectiveBorderRadius,
              ),
            ),
      ),
    );
  }
}
