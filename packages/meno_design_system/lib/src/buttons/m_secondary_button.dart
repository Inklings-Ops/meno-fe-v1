import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A secondary button widget that represents a less prominent action button
/// with optional loading state.
///
/// This button is designed to be used as a secondary action button in the
/// application. It supports an icon and text label and can display a loading
/// indicator when in the loading state. It uses an outlined button style.
///
/// Example usage:
/// ```dart
/// MSecondaryButton(
///   label: 'Cancel',
///   onPressed: () {
///     // Handle button press
///   },
///   loading: false,
/// );
/// ```
///
/// For an icon button version:
/// ```dart
/// MSecondaryButton.icon(
///   label: 'Cancel',
///   icon: Icon(Icons.cancel),
///   onPressed: () {
///     // Handle button press
///   },
///   iconPlacement: MButtonIconPlacement.left,
///   loading: false,
/// );
/// ```
class MSecondaryButton extends MButton {
  /// Creates an instance of [MSecondaryButton] with text only.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [loading]: Indicates whether the button is in a loading state. Defaults
  /// to false.
  /// - [style]: An optional button style to customize the appearance.
  const MSecondaryButton({
    required super.label,
    required super.onPressed,
    super.key,
    this.loading = false,
    super.style,
  });

  /// Creates an instance of [MSecondaryButton] with an icon.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [icon]: The icon to be displayed in the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [iconPlacement]: Specifies where the icon should be placed relative to
  /// the text. Defaults to [MButtonIconPlacement.left].
  /// - [loading]: Indicates whether the button is in a loading state. Defaults
  /// to false.
  /// - [style]: An optional button style to customize the appearance.
  const MSecondaryButton.icon({
    required super.label,
    required super.icon,
    required super.onPressed,
    super.key,
    super.iconPlacement = MButtonIconPlacement.left,
    this.loading = false,
    super.style,
  }) : super.icon();

  /// Indicates whether the button is in a loading state. When true, a loading
  /// indicator is displayed instead of the button's child.
  /// Defaults to false.
  final bool loading;

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return OutlinedButton(
      style: style?.merge(MButtonStyles.of(context)?.secondary),
      onPressed: loading ? null : onPressed,
      child: loading ? const MLoadingIndicator.four(width: 56) : child,
    );
  }
}
