import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A success button widget that represents a prominent action button with a
/// success style.
///
/// This button is designed to indicate a positive action or outcome. It
/// supports an icon and text label and uses a filled button style to highlight
/// its prominence.
///
/// Example usage:
/// ```dart
/// MSuccessButton(
///   label: 'Confirm',
///   onPressed: () {
///     // Handle button press
///   },
/// );
/// ```
///
/// For an icon button version:
/// ```dart
/// MSuccessButton.icon(
///   label: 'Confirm',
///   icon: Icon(Icons.check),
///   onPressed: () {
///     // Handle button press
///   },
///   iconPlacement: MButtonIconPlacement.left,
/// );
/// ```
class MSuccessButton extends MButton {
  /// Creates an instance of [MSuccessButton] with text only.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [style]: An optional button style to customize the appearance.
  const MSuccessButton({
    required super.label,
    required super.onPressed,
    super.key,
    super.style,
  });

  /// Creates an instance of [MSuccessButton] with an icon.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [icon]: The icon to be displayed in the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [iconPlacement]: Specifies where the icon should be placed relative to
  /// the text. Defaults to [MButtonIconPlacement.left].
  /// - [style]: An optional button style to customize the appearance.
  const MSuccessButton.icon({
    required super.label,
    required super.icon,
    required super.onPressed,
    super.key,
    super.iconPlacement = MButtonIconPlacement.left,
    super.style,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return FilledButton(
      style: style?.merge(MButtonStyles.of(context)?.success),
      onPressed: onPressed,
      child: child,
    );
  }
}
