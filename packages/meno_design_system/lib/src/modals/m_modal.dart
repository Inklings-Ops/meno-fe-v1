import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MModal extends StatelessWidget {
  const MModal({
    super.key,
    required this.builder,
    this.title,
    this.showCloseButton = true,
    this.padding,
  });
  final WidgetBuilder builder;
  final String? title;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveContentPadding = title != null
        ? const EdgeInsets.only(top: 48, bottom: 8)
        : const EdgeInsets.only(top: 0, bottom: 8);

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16).radius,
      child: Stack(
        children: [
          if (title != null)
            Positioned.fill(
              top: 0,
              child: MModalTitleBar(
                title: title!,
                showCloseButton: showCloseButton,
              ),
            ),
          Padding(
            padding: effectiveContentPadding.radius,
            child: builder(context),
          ),
        ],
      ),
    );
  }
}
