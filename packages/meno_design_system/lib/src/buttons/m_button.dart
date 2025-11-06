import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Abstract base class for creating buttons with optional icons.
///
/// This class provides a foundation for buttons that can either display only a
/// text label or
/// include an icon alongside the text. It includes functionality to specify the
/// icon placement
/// and customize the button's style.
///
/// The button's appearance and behavior can be further defined in subclasses
/// that implement
/// the `buildButton` method.
///
/// Subclasses can utilize the constructors to create buttons with text-only or
/// text-with-icon variants.
///
/// Example usage:
/// ```dart
/// class MyButton extends MButton {
///   const MyButton({
///     required String label,
///     required VoidCallback? onPressed,
///     Key? key,
///     ButtonStyle? style,
///   }) : super(label: label, onPressed: onPressed, key: key, style: style);
/// }
///
/// MyButton(
///   label: 'Click Me',
///   onPressed: () {},
/// );
/// ```
abstract class MButton extends StatelessWidget {
  /// Creates a button with a text label.
  ///
  /// The button displays only the provided text label.
  ///
  /// Parameters:
  /// - [label]: The text label for the button.
  /// - [onPressed]: The callback to be invoked when the button is pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [style]: An optional [ButtonStyle] to customize the button's appearance.
  const MButton({
    required String label,
    required VoidCallback? onPressed,
    bool? loading,
    Key? key,
    ButtonStyle? style,
  }) : this._(
         key: key,
         label: label,
         onPressed: loading ?? false ? null : onPressed,
         style: style,
         loading: loading,
       );

  /// Creates a button with an icon and text.
  ///
  /// The button displays an icon and a text label. The icon's placement
  /// relative to the text can be specified using the [iconPlacement] parameter.
  ///
  /// Parameters:
  /// - [label]: The text label for the button.
  /// - [icon]: The icon to be displayed alongside the text.
  /// - [onPressed]: The callback to be invoked when the button is pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [iconPlacement]: The placement of the icon relative to the text.
  /// Defaults to [MButtonIconPlacement.left].
  /// - [style]: An optional [ButtonStyle] to customize the button's appearance.
  const MButton.icon({
    required String label,
    required Widget icon,
    required VoidCallback? onPressed,
    Key? key,
    MButtonIconPlacement iconPlacement = MButtonIconPlacement.left,
    ButtonStyle? style,
    bool loading = false,
  }) : this._(
         key: key,
         onPressed: onPressed,
         label: label,
         icon: icon,
         iconPlacement: iconPlacement,
         style: style,
         loading: loading,
       );

  const MButton._({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.iconPlacement = MButtonIconPlacement.left,
    this.style,
    this.loading,
  });

  /// The text label for the button.
  final String label;

  /// The icon to be displayed alongside the text.
  ///
  /// This property is optional. If null, the button will display only the text
  /// label.
  final Widget? icon;

  /// The placement of the icon relative to the text.
  ///
  /// Defaults to [MButtonIconPlacement.left], which places the icon to the
  /// left of the text.
  final MButtonIconPlacement iconPlacement;

  /// The callback to be invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// The style to customize the appearance of the button.
  final ButtonStyle? style;

  /// The loading state of the button
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (icon != null) {
      child = _MButtonWithIcon(
        iconPlacement: iconPlacement,
        icon: icon!,
        label: label,
      );
    } else {
      child = Text(label);
    }

    return buildButton(
      context,
      loading ?? false ? const MLoadingIndicator.four() : child,
    );
  }

  /// Subclasses should implement this method to define the button's appearance.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [child]: The widget that represents the button's content.
  ///
  /// Returns:
  /// A [Widget] that represents the button with the given content.
  Widget buildButton(BuildContext context, Widget child);
}

/// A button widget that displays an icon and text in a row.
///
/// This widget is used internally by [MButton] to render the icon and text
/// with the specified placement.
class _MButtonWithIcon extends StatelessWidget {
  /// Creates an instance of [_MButtonWithIcon].
  ///
  /// Parameters:
  /// - [icon]: The icon to be displayed.
  /// - [label]: The text label for the button.
  /// - [iconPlacement]: The placement of the icon relative to the text.
  const _MButtonWithIcon({
    required this.icon,
    required this.label,
    required this.iconPlacement,
  });

  /// The icon to be displayed in the button.
  final Widget icon;

  /// The text label for the button.
  final String label;

  /// The placement of the icon relative to the text.
  final MButtonIconPlacement iconPlacement;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(14);
    final effectiveScale = clampDouble(scale / 14.0, 1, 2) - 1.0;

    // Replaces the following code:
    // dart```
    //   final gap = SizedBox(width: lerpDouble(8, 4, effectiveScale));
    // ```
    //
    final gap = (lerpDouble(8, 4, effectiveScale) ?? 0).horizontalSpace;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (iconPlacement == MButtonIconPlacement.left) ...[icon, gap],
        Flexible(child: Text(label)),
        if (iconPlacement == MButtonIconPlacement.right) ...[gap, icon],
      ],
    );
  }
}
