import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';

class MModal extends StatelessWidget {
  final WidgetBuilder builder;
  final String? title;
  final bool showCloseButton;

  const MModal({
    super.key,
    required this.builder,
    this.title,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget closeButton = const SizedBox();
    if (showCloseButton) {
      closeButton = MIconButton(
        icon: const Icon(MIcons.x_close),
        color: MColorScheme.of(context)?.onBackground,
        onPressed: () => Navigator.pop(context),
      );
    }

    Widget titleWidget = const SizedBox();
    if (title != null) {
      titleWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MText(title!, style: MTextStyle.subheadingMedium),
                closeButton,
              ],
            ),
          ),
          MSize.verticalSpaceSmall,
          const MDivider(),
        ],
      );
    }

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Stack(
        children: [
          Positioned.fill(
            top: 0,
            child: titleWidget,
          ),
          Padding(
            padding: EdgeInsets.only(top: title != null ? 48 : 8),
            child: builder(context),
          ),
        ],
      ),
    );
  }
}
