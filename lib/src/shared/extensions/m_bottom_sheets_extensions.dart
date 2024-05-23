import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../modals/m_switch_account_modal.dart';

extension MBottomSheetsX on BuildContext {
  Future showModal(
    Widget child, {
    BoxConstraints? constraints,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      context: this,
      builder: (context) => Material(child: child),
      constraints: constraints,
      backgroundColor: MColorScheme.of(this)?.background,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: true,
      useSafeArea: true,
    );
  }

  Future showSwitchAccountSheet() => showModal(
        const MSwitchAccountModal(),
        isScrollControlled: true,
        useRootNavigator: true,
      );
}
