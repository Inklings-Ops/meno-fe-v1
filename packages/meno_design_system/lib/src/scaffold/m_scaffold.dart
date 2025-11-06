import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A custom scaffold widget with additional features.
///
/// This widget provides a similar structure to the standard `Scaffold` widget
/// but offers additional customization options.
class MScaffold extends StatelessWidget {
  /// Creates a new `MScaffold` widget.
  ///
  /// * `appBar`: The app bar to display at the top of the scaffold.
  /// * `body`: The main content of the scaffold.
  /// * `padding`: The padding to apply to the body content.
  /// * `scrollController`: The scroll controller for the scaffold.
  /// * `resizeToAvoidBottomInset`: Whether to resize the scaffold to avoid
  /// bottom inset.
  /// * `bottomNavigationBar`: The bottom navigation bar to display at the
  /// bottom of the scaffold.
  /// * `persistentFooterButtons`: A list of buttons to display at the bottom
  /// of the scaffold.
  const MScaffold({
    super.key,
    this.appBar,
    this.body,
    this.padding,
    this.scrollController,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar,
    this.persistentFooterButtons,
  });

  /// The app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The main content of the scaffold.
  final Widget? body;

  /// The padding to apply to the body content.
  final EdgeInsets? padding;

  /// The scroll controller for the scaffold.
  final ScrollController? scrollController;

  /// Whether to resize the scaffold to avoid bottom inset.
  final bool? resizeToAvoidBottomInset;

  /// The bottom navigation bar to display at the bottom of the scaffold.
  final Widget? bottomNavigationBar;

  /// A list of buttons to display at the bottom of the scaffold.
  final List<Widget>? persistentFooterButtons;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    body: Padding(
      padding: padding?.r ?? const EdgeInsets.symmetric(horizontal: 16).r,
      child: body,
    ),
    bottomNavigationBar: bottomNavigationBar,
    persistentFooterButtons: persistentFooterButtons,
  );
}
