import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that displays a title bar for a modal.
///
/// The [MModalTitleBar] includes a title and an optional close button.
/// It can be used to provide a consistent header for modal dialogs.
///
/// Example usage:
/// ```dart
/// MModalTitleBar(
///   title: 'Modal Title',
///   showCloseButton: true,
///   padding: EdgeInsets.all(16.0),
/// );
/// ```
class MModalTitleBar extends StatelessWidget {
  /// Creates an instance of [MModalTitleBar].
  ///
  /// The [title] parameter is required. The [showCloseButton] parameter
  /// determines whether a close button is displayed, and defaults to `true`.
  /// The [padding] parameter can be used to add custom padding to the title
  /// bar.
  const MModalTitleBar({
    required this.title,
    super.key,
    this.showCloseButton = true,
    this.padding,
  });

  /// The title text displayed in the title bar.
  final String title;

  /// Determines whether the close button is displayed.
  ///
  /// Defaults to `true`.
  final bool showCloseButton;

  /// Custom padding for the title bar.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MText(title, style: textTheme.subheadingMedium),
                if (showCloseButton)
                  MIconButton(
                    icon: const Icon(MIcons.x_close),
                    color: MColorScheme.of(context).onBackgroundVariant,
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          Spaces.verticalSmall,
          const MDivider(),
        ],
      ),
    );
  }
}
