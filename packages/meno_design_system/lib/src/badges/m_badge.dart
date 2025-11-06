import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A customizable badge widget that displays various status indicators with
/// optional styles.
///
/// The [MBadge] widget can be used to display different types of badges such
/// as 'Co-host', 'Host', 'LIVE', 'OFF-AIR',
/// 'RECONNECTING', and 'NEW'. It supports customization of appearance, size,
/// and optional border and loader indicators.
///
/// Example usage:
/// ```dart
/// MBadge.cohost(context)
/// ```
/// ```dart
/// MBadge.live(count: '10', showLoader: true)
/// ```
class MBadge extends StatelessWidget {
  /// Creates a co-host badge with predefined styles.
  ///
  /// The [context] parameter is used to access the theme for text styling.
  MBadge.cohost(BuildContext context, {Key? key})
    : this._(
        key: key,
        value: 'Co-host',
        height: 20,
        width: 60,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: MColor.grey30,
        valueColor: MColor.primary700,
        textStyle: MTextTheme.of(context).microMedium,
      );

  /// Creates a host badge with predefined styles.
  ///
  /// The [context] parameter is used to access the theme for text styling.
  MBadge.host(BuildContext context, {Key? key})
    : this._(
        key: key,
        value: 'Host',
        constraints: const BoxConstraints(minHeight: 20, maxWidth: 59),
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: MColor.grey30,
        valueColor: MColor.primary700,
        textStyle: MTextTheme.of(context).microMedium,
      );

  /// Creates a large badge with a customizable value.
  ///
  /// The [value] parameter is required and specifies the text to display on
  /// the badge.
  /// The [key] parameter can be used to uniquely identify this widget in the
  /// widget tree.
  const MBadge.large({required String value, Key? key})
    : this._(
        key: key,
        value: value,
        constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
      );

  /// Creates a live badge with optional loader and border indicators.
  ///
  /// The [count] parameter specifies the view count to display on the badge.
  /// The [showLoader] parameter indicates whether to display a loader.
  /// The [showBorder] parameter indicates whether to display a border around
  /// the badge.
  /// The [key] parameter can be used to uniquely identify this widget in the
  /// widget tree.
  const MBadge.live({
    Key? key,
    String? count,
    bool showLoader = false,
    bool showBorder = false,
  }) : this._(
         key: key,
         value: 'LIVE',
         viewCount: count,
         height: 20,
         showLoader: showLoader,
         constraints: const BoxConstraints(minHeight: 20),
         padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
         showBorder: showBorder,
       );

  /// Creates an off-air badge with predefined styles.
  ///
  /// The [context] parameter is used to access the theme for colors.
  MBadge.offAir(BuildContext context, {Key? key})
    : this._(
        key: key,
        value: 'OFF-AIR',
        height: 20,
        constraints: const BoxConstraints(minHeight: 20),
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        color: MColorScheme.of(context).disabledContainer,
        valueColor: MColorScheme.of(context).onDisabled,
      );

  /// Creates a reconnecting badge with predefined styles.
  ///
  /// The [context] parameter is used to access the theme for colors.
  MBadge.reconnecting(BuildContext context, {Key? key})
    : this._(
        key: key,
        value: 'RECONNECTING',
        height: 20,
        constraints: const BoxConstraints(minHeight: 20),
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        color: MColorScheme.of(context).errorContainer,
        valueColor: MColorScheme.of(context).onErrorContainer,
      );

  /// Creates a new badge with a customizable value.
  ///
  /// The [value] parameter is required and specifies the text to display on
  /// the badge.
  /// The [key] parameter can be used to uniquely identify this widget in the
  /// widget tree.
  MBadge.newBadge(BuildContext context, {Key? key})
    : this._(
        key: key,
        value: 'NEW',
        constraints: const BoxConstraints(minHeight: 16),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        valueColor: MColorScheme.of(context).primary,
        color: MInternal.resolve(
          Theme.of(context).brightness == Brightness.light,
          MColor.newBadgeLight,
          MColor.newBadgeDark,
        ),
      );

  /// Creates a small badge with a minimal size.
  ///
  /// The [key] parameter can be used to uniquely identify this widget in the
  /// widget tree.
  const MBadge.small({Key? key})
    : this._(
        key: key,
        height: 6,
        width: 6,
        constraints: const BoxConstraints(minHeight: 6, minWidth: 6),
      );

  /// Creates a badge with custom styles.
  ///
  /// The [color] parameter specifies the background color of the badge.
  /// The [value] parameter specifies the text to display on the badge.
  /// The [viewCount] parameter specifies an optional view count.
  /// The [textStyle] parameter specifies the style for the badge text.
  /// The [valueColor] parameter specifies the color of the badge text.
  /// The [borderRadius] parameter specifies the border radius of the badge.
  /// The [height] and [width] parameters specify the size of the badge.
  /// The [padding] parameter specifies the padding around the badge content.
  /// The [constraints] parameter specifies the constraints on the badge size.
  /// The [showLoader] parameter indicates whether to show a loader.
  /// The [showBorder] parameter indicates whether to show a border around the
  /// badge.
  const MBadge._({
    super.key,
    this.color,
    this.value,
    this.viewCount,
    this.textStyle,
    this.valueColor,
    this.borderRadius = Corners.circle,
    this.height,
    this.width,
    this.padding,
    this.constraints,
    this.showLoader = false,
    this.showBorder = false,
  });

  /// The background color of the badge.
  final Color? color;

  /// The text to display on the badge.
  final String? value;

  /// An optional view count to display on the badge.
  final String? viewCount;

  /// The style for the badge text.
  final TextStyle? textStyle;

  /// The color of the badge text.
  final Color? valueColor;

  /// The border radius of the badge.
  final BorderRadius? borderRadius;

  /// The height of the badge.
  final double? height;

  /// The width of the badge.
  final double? width;

  /// The padding around the badge content.
  final EdgeInsets? padding;

  /// The constraints on the badge size.
  final BoxConstraints? constraints;

  /// Whether to show a loader on the badge.
  final bool showLoader;

  /// Whether to show a border around the badge.
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    Widget? child;

    if (value != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLoader)
            Assets.images.loading.image(color: valueColor ?? colors.onError),
          _buildText(context, content: value!),
          if (viewCount != null) ...[
            6.horizontalSpace,
            _buildText(context, content: viewCount!),
          ],
        ],
      );
    }

    return Skeleton.leaf(
      child: Container(
        height: height?.h,
        width: width?.w,
        padding: padding?.r,
        constraints: constraints?.r,
        decoration: ShapeDecoration(
          color: color ?? colors.error,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius?.r ?? BorderRadius.zero,
            side: showBorder
                ? BorderSide(color: valueColor ?? Colors.white)
                : BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildText(BuildContext context, {required String content}) {
    final colors = MColorScheme.of(context);
    return MText.micro(
      content,
      textAlign: TextAlign.center,
      style: textStyle,
      letterSpacing: 0.5,
      color: valueColor ?? colors.onError,
    );
  }
}
