import 'package:flutter/material.dart';
import 'package:meno_design_system/src/modals/m_modal_title_bar.dart';

class MModal extends StatelessWidget {
  final WidgetBuilder builder;
  final String? title;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;

  const MModal({
    super.key,
    required this.builder,
    this.title,
    this.showCloseButton = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
            padding: EdgeInsets.only(top: title != null ? 48 : 0, bottom: 8),
            child: builder(context),
          ),
        ],
      ),
    );
  }
}
