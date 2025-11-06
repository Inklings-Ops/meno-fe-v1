import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that displays a title bar for a modal.
///
/// The [MModalTitleBar] includes a title and an optional close button. It can
/// be used to provide a consistent header for modal dialogs.
class MModal extends StatelessWidget {
  /// Creates an instance of [MModalTitleBar].
  ///
  /// The [title] parameter is required. The [showCloseButton] parameter
  /// determines whether a close button is displayed, and defaults to `true`.
  /// The [padding] parameter can be used to add custom padding to the title
  /// bar.
  const MModal({
    required this.builder,
    super.key,
    this.title,
    this.showCloseButton = true,
    this.padding,
  });

  /// WidgetBuilder for the modal.
  final WidgetBuilder builder;

  /// The title text displayed in the title bar.
  final String? title;

  /// Determines whether the close button is displayed.
  ///
  /// Defaults to `true`.
  final bool showCloseButton;

  /// Custom padding for the title bar.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveContentPadding = title != null
        ? const EdgeInsets.only(top: 48, bottom: 8).r
        : const EdgeInsets.only(bottom: 8).r;

    return SafeArea(
      child: Container(
        width: 1.sw,
        padding: padding?.r ?? const EdgeInsets.fromLTRB(16, 0, 16, 16).r,
        child: Stack(
          children: [
            if (title != null)
              Positioned.fill(
                child: MModalTitleBar(
                  title: title!,
                  showCloseButton: showCloseButton,
                ),
              ),
            Padding(padding: effectiveContentPadding, child: builder(context)),
          ],
        ),
      ),
    );
  }
}
