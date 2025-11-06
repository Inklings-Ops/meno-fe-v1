import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A button styled to represent Google sign-in or action.
///
/// This button displays a Google icon alongside a label and can trigger a
/// callback
/// when pressed.
///
/// Example usage:
/// ```dart
/// MGoogleButton(
///   title: 'Sign in with Google',
///   onPressed: () {
///     // Handle Google sign-in action.
///   },
/// );
/// ```
class MGoogleButton extends StatelessWidget {
  /// Creates an instance of [MGoogleButton].
  ///
  /// Parameters:
  /// - [title]: The text label to be displayed on the button.
  /// - [key]: An optional key to identify the widget.
  /// - [onPressed]: An optional callback function to be invoked when the
  /// button is pressed.
  const MGoogleButton({
    required this.title,
    super.key,
    this.onPressed,
  });

  /// The text label to be displayed on the button.
  final String title;

  /// The callback function to be invoked when the button is pressed.
  ///
  /// If not provided, the button will not perform any action when pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return MSecondaryButton.icon(
      label: title,
      icon: Assets.images.google.svg(),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.50, color: colors.inActiveContainer),
        foregroundColor: colors.onBackground,
        backgroundColor: colors.background,
      ),
    );
  }
}
