import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double _kMinSize = 24;

const BoxConstraints _kConstraints = BoxConstraints(
  minWidth: _kMinSize,
  minHeight: _kMinSize,
);

/// A customizable icon button widget.
///
/// This widget represents a circular button with an icon. It supports
/// customization of size, color, and padding, and can be either filled or
/// outlined.
///
/// The button can trigger a callback when pressed.
///
/// Example usage:
/// ```dart
/// MIconButton(
///   icon: Icon(Icons.add),
///   size: 32,
///   iconSize: 20,
///   color: Colors.white,
///   fillColor: Colors.blue,
///   onPressed: () {
///     // Handle button press
///   },
/// );
/// ```
class MIconButton extends StatelessWidget {
  /// Creates an instance of [MIconButton].
  ///
  /// Parameters:
  /// - [icon]: The icon widget to be displayed inside the button.
  /// - [key]: An optional key to identify the widget.
  /// - [size]: The size of the button (diameter of the circle). Defaults to 24.
  /// - [iconSize]: The size of the icon. If not provided, it defaults to
  /// [size].
  /// - [color]: The color of the icon. If not provided, it defaults to the
  /// theme's icon color.
  /// - [fillColor]: The background color of the button when [isFilled] is true.
  /// - [isFilled]: Whether the button should have a filled background.
  /// Defaults to false.
  /// - [onPressed]: An optional callback function to be invoked when the
  /// button is pressed.
  /// - [padding]: The padding around the icon when the button is filled.
  /// Defaults to zero if [isFilled] is false.
  /// - [constraints]: Optional constraints for the button.
  /// - [isDisabled]: Whether the button is disabled. If true, the button will
  /// not respond to taps. Defaults to false.
  const MIconButton({
    required this.icon,
    super.key,
    this.size = 24,
    this.iconSize,
    this.color,
    this.fillColor,
    this.isFilled = false,
    this.onPressed,
    this.padding,
    this.constraints,
    this.isDisabled = false,
  });

  /// The icon widget to be displayed inside the button.
  final Widget icon;

  /// The size of the button (diameter of the circle). Defaults to 24.
  final double size;

  /// The size of the icon. If not provided, it defaults to [size].
  final double? iconSize;

  /// The color of the icon. If not provided, it defaults to the theme's icon
  /// color.
  final Color? color;

  /// The background color of the button when [isFilled] is true.
  final Color? fillColor;

  /// Whether the button should have a filled background. Defaults to false.
  final bool isFilled;

  /// An optional callback function to be invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// The padding around the icon when the button is filled. Defaults to zero
  /// if [isFilled] is false.
  final EdgeInsetsGeometry? padding;

  /// Optional constraints for the button.
  final BoxConstraints? constraints;

  /// Whether the button is disabled. If true, the button will not respond to
  /// taps. Defaults to false.
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;
    final effectiveSize = theme.iconTheme.size ?? size;
    final boxConstraints = visualDensity.effectiveConstraints(_kConstraints).r;
    return InkResponse(
      radius: math.max(Material.defaultSplashRadius, size),
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: size.r,
        width: size.r,
        alignment: Alignment.center,
        constraints: constraints?.r ?? boxConstraints,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFilled ? fillColor : null,
        ),
        padding: isFilled ? padding : EdgeInsets.zero,
        child: SizedBox.square(
          dimension: effectiveSize.r,
          child: IconTheme.merge(
            data: IconThemeData(
              size: iconSize?.sp ?? effectiveSize.sp,
              color: color ?? theme.iconTheme.color,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
