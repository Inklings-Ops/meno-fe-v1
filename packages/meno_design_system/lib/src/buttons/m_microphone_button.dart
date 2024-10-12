import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A button widget that represents a microphone control.
///
/// This widget displays a microphone icon that changes based on the mute state.
/// It can trigger a callback when tapped.
///
/// Example usage:
/// ```dart
/// MMicrophoneButton(
///   isMuted: true,
///   onTap: () {
///     // Handle microphone button tap
///   },
/// );
/// ```
class MMicrophoneButton extends StatelessWidget {
  /// Creates an instance of [MMicrophoneButton].
  ///
  /// Parameters:
  /// - [key]: An optional key to identify the widget.
  /// - [isMuted]: Indicates whether the microphone is muted. Defaults to true.
  /// - [onTap]: An optional callback function to be invoked when the button is
  /// tapped.
  const MMicrophoneButton({
    super.key,
    this.isMuted = true,
    this.onTap,
    this.isDisabled = false,
  });

  /// Whether the microphone is muted. If true, the microphone-off icon is
  /// displayed.
  /// If false, the microphone icon is displayed. Defaults to true.
  final bool isMuted;

  /// An optional callback function to be invoked when the button is tapped.
  final VoidCallback? onTap;

  /// Whether the button is disabled. If true, the button will not respond to
  /// taps. Defaults to false.
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MIconButton(
      icon: isMuted
          ? const Icon(MIcons.microphone_off)
          : const Icon(MIcons.microphone),
      color: isDisabled ? colors.primary?.withOpacity(0.4) : colors.primary,
      isFilled: true,
      iconSize: 20,
      size: 40,
      fillColor: colors.primary?.withOpacity(0.1),
      onPressed: onTap,
      isDisabled: isDisabled,
    );
  }
}
