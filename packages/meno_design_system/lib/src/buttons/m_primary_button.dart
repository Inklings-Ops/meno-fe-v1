import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A primary button widget that represents an action button with optional
/// loading and disabled states.
///
/// This button is designed to be used as a primary action button in the
/// application. It supports an icon and text label and can display a loading
/// indicator when in the loading state. It also supports a disabled state
/// where it does not respond to user interactions.
///
/// Example usage:
/// ```dart
/// MPrimaryButton(
///   label: 'Submit',
///   onPressed: () {
///     // Handle button press
///   },
///   loading: false,
///   disabled: false,
/// );
/// ```
///
/// For an icon button version:
/// ```dart
/// MPrimaryButton.icon(
///   label: 'Submit',
///   icon: Icon(Icons.send),
///   onPressed: () {
///     // Handle button press
///   },
///   iconPlacement: MButtonIconPlacement.left,
///   loading: false,
///   disabled: false,
/// );
/// ```
class MPrimaryButton extends MButton {
  /// Creates an instance of [MPrimaryButton] with text only.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [disabled]: Indicates whether the button is in a disabled state.
  /// Defaults to false.
  /// - [loading]: Indicates whether the button is in a loading state.
  /// Defaults to false.
  /// - [style]: An optional button style to customize the appearance.
  const MPrimaryButton({
    required super.label,
    required super.onPressed,
    super.key,
    this.disabled = false,
    bool loading = false,
    super.style,
  }) : _loading = loading;

  /// Creates an instance of [MPrimaryButton] with an icon.
  ///
  /// Parameters:
  /// - [label]: The text label of the button.
  /// - [icon]: The icon to be displayed in the button.
  /// - [onPressed]: The callback function to be invoked when the button is
  /// pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [iconPlacement]: Specifies where the icon should be placed relative to
  /// the text. Defaults to [MButtonIconPlacement.left].
  /// - [loading]: Indicates whether the button is in a loading state.
  /// Defaults to false.
  /// - [disabled]: Indicates whether the button is in a disabled state.
  /// Defaults to false.
  /// - [style]: An optional button style to customize the appearance.
  const MPrimaryButton.icon({
    required super.label,
    required super.icon,
    required super.onPressed,
    super.key,
    super.iconPlacement = MButtonIconPlacement.left,
    bool loading = false,
    this.disabled = false,
    super.style,
  })  : _loading = loading,
        super.icon();

  /// Indicates whether the button is in a loading state. When true, a loading
  /// indicator is displayed instead of the button's child. Defaults to false.
  final bool _loading;

  @override
  bool get loading => _loading;

  /// Indicates whether the button is in a disabled state. When true, the
  /// button is non-interactive and does not respond to user input.
  /// Defaults to false.
  final bool disabled;

  @override
  Widget buildButton(BuildContext context, Widget child) {
    return ElevatedButton(
      style: style?.merge(MButtonStyles.of(context)?.primary),
      onPressed: (loading || disabled) ? null : onPressed,
      child: loading ? const MLoadingIndicator.four(width: 56) : child,
    );
  }
}
