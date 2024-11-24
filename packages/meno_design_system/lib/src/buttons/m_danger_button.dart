import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Creates an instance of [MDangerButton] with a text label.
///
/// Parameters:
/// - [label]: The text label for the button.
/// - [onPressed]: The callback to be invoked when the button is pressed.
/// - [key]: An optional key to identify the widget.
/// - [style]: An optional [ButtonStyle] to customize the button's appearance.
class MDangerButton extends MButton {
  /// Creates an instance of [MDangerButton] with a text label.
  ///
  /// Parameters:
  /// - [label]: The text label for the button.
  /// - [onPressed]: The callback to be invoked when the button is pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [style]: An optional [ButtonStyle] to customize the button's appearance.
  const MDangerButton({
    required super.label,
    required super.onPressed,
    super.key,
    super.loading,
    super.style,
  });

  /// Creates an instance of [MDangerButton] with an icon and a text label.
  ///
  /// Parameters:
  /// - [label]: The text label for the button.
  /// - [icon]: The icon to be displayed alongside the text.
  /// - [onPressed]: The callback to be invoked when the button is pressed.
  /// - [key]: An optional key to identify the widget.
  /// - [iconPlacement]: The placement of the icon relative to the text.
  /// Defaults to [MButtonIconPlacement.left].
  /// - [style]: An optional [ButtonStyle] to customize the button's appearance.
  const MDangerButton.icon({
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
      style: style?.merge(MButtonStyles.of(context)?.danger),
      onPressed: onPressed,
      child: child,
    );
  }
}
