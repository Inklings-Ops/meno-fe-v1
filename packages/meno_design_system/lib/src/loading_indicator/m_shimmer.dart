import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a shimmering effect, commonly used as a loading
/// placeholder. The shimmer effect can be customized in terms of color,
/// shape, and size. When disabled, the child widget is displayed as-is
/// without any shimmering effect.
///
/// This widget uses the `Shimmer.fromColors` constructor to create a
/// shimmering effect, transitioning between a base and highlight color.
/// These colors can be customized via the `MColorScheme` of the context.
///
/// The shimmer effect can be applied to any child widget or can show a
/// basic placeholder with customizable dimensions and shape if no child
/// widget is provided.
///
/// ### Note:
/// The `MColorScheme` is expected to provide `background` and `surfaceShade`
/// colors used as the base and highlight colors for the shimmer effect.
class MShimmer extends StatelessWidget {
  /// **Example usage:**
  ///
  /// ```dart
  /// MShimmer(
  ///   enabled: true,
  ///   height: 100,
  ///   width: 100,
  ///   shape: BoxShape.circle,
  ///   backgroundColor: Colors.grey[300],
  /// )
  /// ```
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

  /// `enabled` (bool): Determines if the shimmer effect is active.
  /// If `false`, only the `child` widget or the placeholder is displayed
  /// without shimmer. Defaults to `true`.
  final bool enabled;

  /// `child` (Widget?): The widget to be displayed within the shimmer
  /// effect. If `null`, a placeholder container is shown instead.
  final Widget? child;

  /// `backgroundColor` (Color?): The color of the placeholder background.
  /// If `null`, defaults to the `background` color from `MColorScheme`.
  final Color? backgroundColor;

  /// `height` (double?): The height of the placeholder container if no
  /// child widget is provided. Ignored if `child` is not `null`.
  final double? height;

  /// `width` (double?): The width of the placeholder container if no
  /// child widget is provided. Defaults to `double.infinity` if `child`
  /// is `null`.
  final double? width;

  /// `borderRadius` (double?): The corner radius of the rectangular
  /// placeholder. Ignored if `shape` is set to `BoxShape.circle`.
  /// Defaults to `4.0`.
  final double? borderRadius;

  /// `shape` (BoxShape): The shape of the placeholder container, either
  /// `BoxShape.rectangle` or `BoxShape.circle`.
  /// Defaults to `BoxShape.rectangle`.
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final isCircle = shape == BoxShape.circle;
    final effectiveBorderRadius = BorderRadius.circular(borderRadius ?? 4);
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
              height: height,
              width: width ?? double.infinity,
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
