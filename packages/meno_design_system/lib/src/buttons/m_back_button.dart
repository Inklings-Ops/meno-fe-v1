import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

/// Enum for defining the variant of the action button.
enum _ActionButtonVariant { icon, withText }

/// A button that represents a "Back" action. It can be displayed as an icon or
/// with accompanying text.
///
/// The [MBackButton] widget can be used to navigate back in the application.
/// It supports two variants:
/// - An icon-only button
/// - An icon with text
///
/// Example usage:
/// ```dart
/// MBackButton(
///   onPressed: () {
///     // Handle back action
///   },
/// )
/// ```
///
/// ```dart
/// MBackButton.withText(
///   title: 'Back',
///   onPressed: () {
///     // Handle back action
///   },
/// )
/// ```
class MBackButton extends _ActionButton {
  /// Creates a back button with an icon only.
  ///
  /// The [onPressed] parameter is the callback that is triggered when the
  /// button is pressed.
  /// The [color] parameter specifies the color of the icon.
  const MBackButton({
    super.key,
    super.onPressed,
    super.color,
  }) : super(variant: _ActionButtonVariant.icon);

  /// Creates a back button with an icon and text.
  ///
  /// The [title] parameter specifies the text to display next to the icon.
  /// The [iconColor] parameter specifies the color of the icon.
  /// The [textStyle] parameter specifies the style for the text.
  /// The [onPressed] parameter is the callback that is triggered when the
  /// button is pressed.
  const factory MBackButton.withText({
    Key? key,
    String? title,
    Color? iconColor,
    TextStyle? textStyle,
    VoidCallback? onPressed,
  }) = _MBackButtonWithText;

  /// Creates a back button with customizable properties.
  ///
  /// This constructor is used internally to handle different button variants.
  const MBackButton._({
    super.key,
    super.onPressed,
    super.color,
    super.textStyle,
    super.title,
    super.variant,
  });
}

/// An abstract class representing a base action button with common properties.
///
/// This class is extended by [MBackButton] to provide common functionality for
/// action buttons.
///
/// The [variant] parameter specifies the variant of the button (icon-only or
/// with text).
/// The [onPressed] parameter is the callback triggered when the button is
/// pressed.
/// The [color] parameter specifies the color of the button.
/// The [title] parameter specifies the text to display (if applicable).
/// The [textStyle] parameter specifies the style for the text.
abstract class _ActionButton extends StatelessWidget {
  /// Creates an action button with customizable properties.
  ///
  /// The [variant] parameter specifies the variant of the button (icon-only or
  /// with text).
  /// The [onPressed] parameter is the callback triggered when the button is
  /// pressed.
  /// The [color] parameter specifies the color of the button.
  /// The [title] parameter specifies the text to display (if applicable).
  /// The [textStyle] parameter specifies the style for the text.
  const _ActionButton({
    super.key,
    this.variant = _ActionButtonVariant.icon,
    this.onPressed,
    this.color,
    this.title,
    this.textStyle,
  });

  /// The variant of the action button (icon-only or with text).
  final _ActionButtonVariant variant;

  /// The callback that is triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// The color of the button.
  final Color? color;

  /// The text to display next to the icon (if applicable).
  final String? title;

  /// The style for the text (if applicable).
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final resolveColor = MInternal.resolve(isLight, MColor.black, MColor.white);

    return switch (variant) {
      _ActionButtonVariant.icon => MIconButton(
          onPressed: () => _onPressed(context),
          icon: const Icon(MIcons.chevron_left),
          color: color,
        ),
      _ActionButtonVariant.withText => GestureDetector(
          onTap: () => _onPressed(context),
          child: Row(
            children: [
              Icon(
                MIcons.chevron_left,
                color: color ?? resolveColor,
                size: 16,
              ),
              MText(
                title ?? 'Back',
                style: textStyle ?? textTheme.captionMedium,
                color: color ?? resolveColor,
              ),
            ],
          ),
        ),
    };
  }

  /// Handles the button press action.
  ///
  /// If [onPressed] is not null, it will be invoked. Otherwise, it will
  /// attempt to navigate back in the app.
  void _onPressed(BuildContext context) {
    if (onPressed != null) {
      return onPressed!();
    } else {
      Navigator.maybePop(context);
    }
  }
}

/// A back button with text that extends [MBackButton].
///
/// This class is used internally to create a back button with an icon and text.
class _MBackButtonWithText extends MBackButton {
  /// Creates a back button with an icon and text.
  ///
  /// The [title] parameter specifies the text to display next to the icon.
  /// The [iconColor] parameter specifies the color of the icon.
  /// The [textStyle] parameter specifies the style for the text.
  /// The [onPressed] parameter is the callback that is triggered when the
  /// button is pressed.
  const _MBackButtonWithText({
    super.key,
    super.title = 'Back',
    super.textStyle,
    super.onPressed,
    Color? iconColor,
  }) : super._(variant: _ActionButtonVariant.withText, color: iconColor);
}
