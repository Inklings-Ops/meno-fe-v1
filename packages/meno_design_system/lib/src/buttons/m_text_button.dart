import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A text button widget that represents a button with a text-only style.
///
/// This button is designed to have a minimal appearance and is suitable for
/// less prominent actions or for use in contexts where a flat button style is
/// desired. It supports an optional icon and text label.
///
/// Example usage:
/// ```dart
/// MTextButton(
///   label: 'Submit',
///   onPressed: () {
///     // Handle button press
///   },
/// );
/// ```
///
/// For an icon button version:
/// ```dart
/// MTextButton.icon(
///   label: 'Submit',
///   icon: Icon(Icons.send),
///   onPressed: () {
///     // Handle button press
///   },
///   iconPlacement: MButtonIconPlacement.left,
/// );
/// ```
class MTextButton extends MButton {
  /// Creates an instance of [MTextButton] with text only.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [style]: An optional button style to customize the appearance.
  const MTextButton({
    required super.label,
    required super.onPressed,
    super.key,
    super.style,
  });

  /// Creates an instance of [MTextButton] with an icon.
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
  const MTextButton.icon({
    required super.label,
    required super.icon,
    required super.onPressed,
    super.key,
    super.iconPlacement = MButtonIconPlacement.left,
    super.style,
  }) : super.icon();

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return TextButton(
      style: style?.merge(MButtonStyles.of(context)?.text),
      onPressed: onPressed,
      child: child,
    );
  }
}
